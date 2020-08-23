2020-08-13_08:18:28

# Precompiled headers

Unreal Engine uses precompiled headers (or not, unsure).
This is configured in each module's `.Build.cs`.
The build target class has members such as `PrecompileForTargets` and `PCHUsage`.
They can, for example, be set as follows:

```c++
PrecompileForTargets = PrecompileTargetsType.Any;
PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
```

I don't know what this does and how these should be set for various situations.

There may be more information at https://docs.unrealengine.com/en-US/Programming/BuildTools/UnrealBuildTool/IWYU/index.html