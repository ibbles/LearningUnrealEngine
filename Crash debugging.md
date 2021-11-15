2021-02-03_07:59:13

# Crash debugging

## GPU

To debug GPU crashes: `-gpucrashdebugging`
Unreal Engine 4.26 also added `-vulkanbestpractices` and `-gpuvalidation`.
Also `-vulkanvalidation=5` and making sure you have a Vulkan SDK setup so the validation layers are there.

## CPU

Usually a crash reporter will appear with some debug information, and it's possible to attach a debugger at this time.
If a crash is so bad that not even the crash reporter get a chance to do its thing one can enable core dumping.
Enable unlimited core dump file size in the shell from which Unreal Editor is started with `ulimit -c unlimited`.
Pass `-core` when running Unreal Editor.
Do whatever you need to do to reproduce the crash.
A `core` file will be created.
Open the `core` file with GDB: `gdb UnrealEditor -c core`
Not sure where the `core` file will be placed, may need to do `find . -name core` to find it.