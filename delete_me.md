While looking through this I realize that it may not be as useful to you as I though.
Gonna sent it anyway, since you asked and I promised.

It's not a straight-up copy paste, I don't think I'm allowed to do that and it wouldn't be all that helpful to you anyway. Consider this inspiration for how to do things like this.

Stuff within `<>` should be replaced with whatever you have.

First up is the `Dockerfile`. Is pretty much a stock `ubuntu` image, but with some stuff to download and unpack our pre-built Unreal Engine binaries and to run the Python scripts for project building.

```
FROM ubuntu:20.04

ENV LANG=en_us.UTF-8

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
    git \
    python3 \
    unzip \
    wget \
    zip

# Add user "gitagent" to the image with the same ID as gitlab-runner.
RUN adduser --quiet --uid 1004 --disabled-password --gecos '' gitagent
RUN echo "gitagent:<PASSWORD>" | chpasswd
RUN mkdir /home/gitagent/workspace
RUN chown gitagent:gitagent /home/gitagent/workspace

# Download the Unreal Engine binary archive.
# The DOWNLOADED_UNREAL_ENGINE environment variable is used by the build
# scripts to find the Unreal Engine binaries.
RUN mkdir -p /home/gitagent/workspace/UnrealEngine
RUN wget -q <SHARED NETWORK DRIVE>/UnrealEngine_4.25_stripped.zip && \
    unzip -q UnrealEngine_4.25_stripped.zip -d /home/jenkins/workspace/UnrealEngine && \
    rm UnrealEngine_4.25_stripped.zip && \
    chown -R gitagent:gitagent /home/gitagent/workspace/UnrealEngine
ENV DOWNLOADED_UNREAL_ENGINE=/home/gitagent/workspace/UnrealEngine/UnrealEngine_4.25_stripped
```

Unfortunately I don't have access to script we use to build Unreal Engine, but it's not much more than calling `Setup.sh ; ./GenerateProjectFiles.sh ; make ; rm -rf <SOME FOLDERS> ; zip -r UnrealEngine_4.25_stripped.zip *`. This is the part I hope can be done better. Let me know if you find a way.


The `.gitlab-ci.yml`  file is used by GitLab to know when to do what. Here is where we call the builder scripts.

There is one stage, `docker-image-build` that is run by natively, i.e., not in a Docker container, that builds the Docker image.

The other stage, `full-build-and-package` is run in a Docker container, using the Docker image created with the Dockerfile listed above.

```
stages:
  - full-build-and-package
  - docker-image-build

variables:
  DOCKER_REGISTRY: <YOUR DOCKER REGISTRY URL>
  IMAGE_TAG: latest

build-docker-image_ubuntu-20.04_ue-4.25:
  stage:
    docker-image-build
  tags:
    - linux
    - docker-host
  before_script:
    - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN $DOCKER_REGISTRY
  script:
    - cd Dockerfiles/<IMAGE NAME> && ./build.sh
    - docker tag <MY PROJECT>/<IMAGE NAME> $DOCKER_REGISTRY/<REGISTRY URL>/<OPTIONAL FOLDERS>/<IMAGE NAME>:$IMAGE_TAG
    - docker push $DOCKER_REGISTRY/<OPTIONAL FOLDERS>/<IMAGE NAME>:$IMAGE_TAG
  only:
    changes:
      - Dockerfiles/<IMAGE NAME>/*
    refs:
      - master
      - merge_requests



full-build:
  image:
    <REGISTRY URL>/<OPTIONAL FOLDERS>/<IMAGE NAME>
  stage:
    full-build-and-package
  tags:
    - linux
    - docker
  script:
    - ./Packaging/build.bash
  only:
    changes:
      - <PATH>/<TO>/<SOURCE>/**/*
    refs:
      - merge_requests
      - master
      - tags
  artifacts:
    expire_in:
      1 month
    paths:
      - <PROJECT BUILD RESULTS TO STORE>


```


`Dockerfiles/<IMAGE>/build.sh` is a script called by `gitlab-ci.yml` to build the Docker image. It's somewhar arbitrarary where `build`/`tag`/`push` is done. Here `build`  is done by the script and `tag` and `push` by `gitlab-ci.yml`. There are reasons for doing the `tag` and `push` separately, mostly for local testing of the Docker image. Like this we can run the `build.sh` script and get a test image that isn't published anywhere.

```
#!/bin/bash

set -e

if [ $# -eq 1 ]; then
    IMAGE_TAG=$1
    shift
else
    IMAGE_TAG=latest
fi

export DOCKER_REGISTRY=<YOUR DOCKER REGISTRY URL>

os=ubuntu-18.04
ue=ue-4.25

IMAGE_NAME=<PROJECT>/${os}_${ue}
IMAGE_PATH=<OPTIONAL FOLDERS>/${IMAGE_NAME}:${IMAGE_TAG}

docker build -t "${IMAGE_NAME}" .
```



The script called by `gitlab-ci.yml`to build the project, `build.bash`, is a simple wrapper to tell the build script where `Dockerfile` unpacked the Unreal Engine binaries.

```shell
#!/bin/bash
python3 Packaging/create_release.py --unreal "${DOWNLOADED_UNREAL_ENGINE}"
```

The actual build script,`Packagin/create_release.py`is pretty big and mostly contains stuff specific to us. In the end it ends up at the following code:

```python
    chdir(unreal_path)
    if (platform.system() == "Linux"):
        run(["./GenerateProjectFiles.sh", project_file_path, "-game", "-Makefile"])
        runuat_path = join(unrealscript_path, "RunUAT.sh")
    elif (platform.system() == "Windows"):
        run(["./GenerateProjectFiles.bat", project_file_path, "-game"])
        runuat_path = join(unrealscript_path, "RunUAT.bat")

    s = ("{} BuildPlugin "
         "-Plugin={}/<PROJECT>.uplugin "
         "-Package={}/<PROJECT> -Rocket".format(
             runuat_path, plugin_path, export_path))
    command = shlex.split(s)
    run(command)

    # Add any other temporary files that we wish to remove from the package
    # archive.
    rmtree(join(export_path, "Saved", "Intermediate"))

    archive_name = "<PROJECT>-{}_package.zip".format(version)
    chdir(export_path)
    run(["zip", "--symlinks", "--quiet", "-r", archive_name, "<PROJECT>"])
    rename(archive_name, join(root_path, archive_name))
```

- `unreal_path` contans what `--unreal ${DOWNLOADED_UNREAL_ENGINE}` resulted in.
- `project_file_path` is the directory where GitLab-CI checkout out our Git branch.
- `unrealscript_path` is `${DOWNLOADED_UNREAL_ENGINE}/Engine/Build/BatchFiles`.
- `plugin_path` is the path to our plugin within the project directory structure.
- `export_path` is a directory outside of the project directory stucture that will be zipped and uploaded. This is the final result of the build.

The file name that the archive get after the final `rename` is that same as the `<PROJECT BUILD RESULTS TO STORE>` in `gitlab-ci.yml`, which is how we tell the system that this is the file that is the result of the entire build process.

As you may have deduced from the above, our product is a plugin rather than a game. You may need to tweak the `s = ` line to suite your needs.
There are `RunUAT` arguments for doing all kinds of stuff with the build system.

