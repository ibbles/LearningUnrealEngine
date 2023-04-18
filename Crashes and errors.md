2021-08-24_17:37:26

# Crashes and errors

##  Crash when opening a Blueprint Tag.Size == Loaded
```
LogOutputDevice: Warning:
Assertion failed: Tag.Size == Loaded
File:$UE_ROOT/Engine/Source/Runtime/CoreUObject/Private/UObject/Class.cpp
Line: 1478

LogCore: Error:
appError called:
Assertion failed: Tag.Size == Loaded File:$UE_ROOT/Engine/Source/Runtime/CoreUObject/Private/UObject/Class.cpp
Line: 1478
```

This seems to be the kind of thing that just happens sometimes. I don't know how to fix it, other than recreate the Blueprint from scratch / restore from version control.

Opening levels containing instances of the Blueprint crashes the editor as well.
No idea what would happen if other Blueprints have references to this one, would those break as well?


## Vulkan memory defragmentation

Unreal Engine 4.26.1 (I think) added Vulkan memory defrag.
Not had this one myself, but some people have frequent crashes on Unreal Engine versions around 4.25, 4.26, 4.26 due to Vulkan memory defragmentation.
It can be enabled or disabled with the `r.Vulkan.EnableDefrag` flag, e.g.:
`-dpcvars=r.Vulkan.EnableDefrag=1`
or by editing `Config/DefaultEngine.ini` in the Unreal Engine installation:
```
[SystemSettings]
r.Vulkan.EnableDefrag=0
```

## Vulkan SDK

Installing the Vulkan SDK has been claimed to fix some crashes.
I'm not entirely sure what this is, what it's for, and how Unreal Engine uses it.
It can be downloaded from [https://vulkan.lunarg.com/sdk/home](https://vulkan.lunarg.com/sdk/home).
Add `PublicAdditionalLibraries.Add(Path.Combine(VulkanSDKPath, "lib", "libvulkan.so"));` to `VulkanRHI.Build.cs`.
Some environment variables will need to be set, not sure which or when they need to be active.
The following paths are just examples.
```bash
VULKAN_SDK="$HOME/.local/share/VulkanSDK/1.2.189.0/x86_64"
export VULKAN_SDK
PATH="$VULKAN_SDK/bin:$PATH"
LD_LIBRARY_PATH="$VULKAN_SDK/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH
VK_LAYER_PATH="$VULKAN_SDK/etc/vulkan/explicit_layer.d"
export VK_LAYER_PATH
```
[The env variables can be found in Vulkan SDK documentation](https://vulkan.lunarg.com/doc/sdk/1.3.243.0/linux/getting_started.html).

Set them according to your installation.

## VendorId != EGpuVendorId::Unknown

Happens when Unreal Engine detect a Vulkan device it doesn't recognize.
```
LogOutputDevice: Error: Ensure condition failed: VendorId != EGpuVendorId::Unknown [File:/media/s800/UnrealEngine_4.25/Engine/Source/Runtime/VulkanRHI/Private/VulkanDevice.cpp] [Line: 182]

```

This happens early in the startup process and is safe as long as there are other Vulkan devices that can be used instead.
In the log, look for lines similar to:
- `LogVulkanRHI: Display: Found 2 device(s)`
- `LogVulkanRHI: Display: Device 0: NVIDIA GeForce RTX 2070 SUPER`
- `LogVulkanRHI: Display: Device 1: llvmpipe (LLVM 12.0.0, 256 bits)`

The failed ensure is related to the device whose information is printed after the ensure.
So if the error is printed between the `Device 0` line and the `Device 1` line then `Device 1` is the problematic one.

