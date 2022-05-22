2020-11-26_12:52:48

# Git

## LFS for binary files

LFS stands for Large File Storage.
Stores binary file data outside of the repository.
The repository holds links into the binary storage.
LFS enabled clients follows those links and replaces them with the actual data.
Not always supported by server and client.
Must be enabled.
Must be configured to track specific files or file types.
Track `.uasset`, `.umap`, and any other large binaries you have stored in the repository, such as images, audio, model sources, etc.

To install the LFS client on Linux run
```bash
$ sudo apt install git-lfs
$ git lfs install
```
This is a system-wide operation not related to any particular Git repository.

To enable LFS tracking of a particular file type in a particular Git repository run
```bash
git lfs track “*.SUFFIX”
```
The double-quotes are important to make the `*.` part survive past shell expansion.
`SUFFIX` is the file suffix of the file type to track with LFS.
Any filename pattern is probably fine, not just file suffixes.

For example
```bash
git lfs track “*.uasset”
```

File name patterns tracked by LFS are listed in a `.gitattributes` file that is crated by `git lfs track`.
Example `.gitattributes` file:
```
*.uasset filter=lfs diff=lfs merge=lfs -text
*.umap filter=lfs diff=lfs merge=lfs -text
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.blend filter=lfs diff=lfs merge=lfs -text
*.blend* filter=lfs diff=lfs merge=lfs -text
*.fbx filter=lfs diff=lfs merge=lfs -text
```
I don't know what each of the columns mean, in particular the `-text` part.

LFS Migrate is used to purge binary files from the revision history and replace them with LFS links.

LFS supports locking, on some hosts/versions.
When enabled, binary files in the working copy start off marked read-only.
Lock the file with LFS to mark it writable and send a lock event to the server.
The lock will fail if another client has already locked the file.

For more information see https://git-lfs.github.com/.

## Editor integration
Unreal Editor has a plugin for working with git repositories.
It can flag assets in the Content Browser as untracked and changed.
It has a built-in diff viewer for some types of assets, such as Blueprints.
Falls back to a text diff for most other assets.
Sort of does nothing for the rest, such as level assets.
Which diff tool to use it set in Top Menu > Edit > Editor Preferences > General > Loading & Saving > Source Control > Tool for diffing text.