2021-10-07_09:50:44

# Clang toolchain

The compiler is stored at `Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64/v16_clang-9.0.1-centos7/x86_64-unknown-linux-gnu/`.
Or something similar, depending on Unreal Engine version.
We call this the "compiler directory".
The standard library is stored at `Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu/`.
We call this the "LibCxx" directory.

Different versions of Unreal Engine use different versions of Clang:
```
UE4 Version    Toolchain
4.27           v19_clang-11.0.1
4.26           v17_clang-10.0.1
4.25           v16_clang-9.0.1
4.23           v15_clang-8.0.1
4.24           v15_clang-8.0.1
4.22           v13_clang-7.0.1
4.21           v12_clang-6.0.1
4.20           v11_clang-5.0.0
```
These are listed at [Native Toolchain @ docs.unrealengine.com](https://docs.unrealengine.com/4.27/en-US/SharingAndReleasing/Linux/NativeToolchain/) and can also be downloaded from [http://cdn.unrealengine.com/Toolchain_Linux/native-linux-TOOLCHAIN-centos7.tar.gz](http://cdn.unrealengine.com/Toolchain_Linux/native-linux-TOOLCHAIN-centos7.tar.gz)


[[2020-08-27_12:24:45]] [Third-party libraries](./Third-party%20libraries.md)  