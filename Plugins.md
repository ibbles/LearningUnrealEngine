2020-09-15_17:27:33

# Plugins

The available plugins are listed in Unreal Editor > Top Menu Bar > Edit > Plugins.
A new plugin can be created from here as well.
There are templates for various types of plugins.
Plugins can exist either in the engine installation or in the project directory.
Engine plugins are in `<UE_ROOT>/Engine/Plugins`.
Project plugins are in `<PROJECT_ROOT>/Plugins`.

Engine plugins can be disabled for a project by adding
```json
"DisableEnginePluginsByDefault": true
```
to the projct's `.uproject` file.

Creating the plugin will create a bunch of files and folders in one of the `Plugins` directories.

Plugins can also be created by hand.
- Create `Plugins` directory in the project's directory.
- Create a directory for the new plugin named `<PluginName>.
- Create a the following directories within `<PluginName>`:
    - `Binaries`. Will contain compiled binaries/dynamically linked library for our plugin.
    - `Content`. Assets and other content we wish to ship with the plugin.
    - `Intermediate`. Temporary build artifacts created by the build system.
    - `Resources`. Have only ever seen this contain an icon. When put something in `Resources` and when in `Content`?
    - `Source/<PluginName>`. The source code for our plugin.
- Create `<PluginName>.uplugin` in the plugin's directory.

A plugin consists of one or more modules.
By default there is a module with the same name as the plugin, hence the `<PluginName>` directory in `Source`.
Additional modules may be created. It's recommended if it helps structure the plugin's functionality.
If you want to provide Editor integration in addition to in-game functionality you must have a separate Editor module.

There is no specific plugin-in API in Unreal Engine.
The entirety of the public interface surface of all module is available to plug-ins.
Plug-ins can also depend on, call functions, and use types in other plug-ins.

Example `<PluginName>.uplugin`:
```
{
    "FileVersion": 3,
    "Version": 1.2.3,
    "VersionName": "1.2.3",
    "FriendlyName": "Name of the plugin",
    "Description": "Description of the plugin.",
    "Category": "Other",
    "CreatedBy": "",
    "CreatedByURL": "",
    "DocsURL": "",
    "MarketplaceURL": "",
    "SupportURL": "",
    "CanContainContent": true,
    "IsBetaVersion": true,
    "Installed": false,
    "Modules": [
        {
            "Name": "PluginName",
            "Type": "Runtime",
            "LoadingPhase": "Default",
            "WhitelistPlatforms": [
                "Win64",
                "Linux"
            ],
            "BlacklistPlatforms": [
                "IOS",
                "Win32"
            ]
        }
    ]
}
```

Example `<PluginName>.Build.cs`:
```csharp
```

Example `<PlugingName>.Target.cs`:
```csharp
```


Example `<PluginName>Editor.Target.cs`:
```csharp
```

[[2020-09-10_19:55:50]] [Modules](./Modules.md)  
