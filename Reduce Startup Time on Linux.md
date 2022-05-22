2022-02-07_07:56:26

# Reduce Startup Time on Linux

Prior to glibc 2.35 a slow dso sorting algorithm was used.
This caused software with many dynamically loaded libraries to take a long time to start.
Pre-releases of the new sorting algorithm are available.
For example for Ubuntu: https://launchpad.net/~slonopotamus/+archive/ubuntu/glibc-dso
```bash
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository ppa:slonopotamus/glibc-dso
$ sudo apt update
$ sudo apt upgrade libc6
```
To use the new sorting algorithm set the `glibc.rtld.dynamic_sort` `GLIBC_TUNABLES` to 2.
```
export GLIBC_TUNABLES=glibc.rtld.dynamic_sort=2
```

This package should be removed when doing system updates, just in case, and when glibc 2.35 is release for  you distribution.

Se also https://github.com/adamrehn/ue4-docker/issues/177 for a discussion.
    TStructOpsTypeTraitsBase2