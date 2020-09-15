2020-09-11_12:52:42

# ModuleType

The type that a C++ module has.
Set in the `Modules` list of a project's `.uproject` or a plugin's `.uplugin`.
Common ones are `Editor` and `Runtime`.
`Editor` means that the module is loaded when opening Unreal Editor.
`Runtime` means that the module is loaded both when opening Unreal Editor and when running as a stand-alone game.
There used to be a `Developer` type as well, but it was deprecated in 4.24.
Using it in 4.25 gives the following warning:

> WARNING: The 'Developer' module type has been deprecated in 4.24. Use 'DeveloperTool' for modules that can be loaded by game/client/server targets in non-shipping configurations, or 'UncookedOnly' for modules that should only be loaded by uncooked editor and program targets (eg. modules containing blueprint nodes)

So I guess one should use `DeveloperTool` instead.
It is related to `bBuildDeveloperTools` which can be set in in `.Target.cs` files.
`DeveloperTool` modules will not be built if `bBuilDeveloperTools` is `false`.

It may be that the type must be `Editor` when depending on editor modules

[4.24 C++ Transition Guide@https://forums.unrealengine.com/](https://forums.unrealengine.com/development-discussion/c-gameplay-programming/1699015-4-24-c-transition-guide)
