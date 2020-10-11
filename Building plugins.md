2020-08-13_08:37:17

# Building plugins

A plugin can be built from the command line with the following command:

`<PathTo>/RunUAT.bat BuildPlugin -Plugin=<path_to_.uplugin> -Package=<path_to_empty_directory>` 

Not sure what that does though.

June Rhodes made a PowerShell script to help with plugin development. Can probably be read to learn more about what command line arguments are useful:
https://gitlab.com/redpointgames/unreal-engine-plugin-build-scripts/-/blob/master/Build.ps1



[https://github.com/EpicGames/UnrealEngine/blob/release/Engine/Source/Programs/AutomationTool/Scripts/BuildPluginCommand.Automation.cs](https://github.com/EpicGames/UnrealEngine/blob/release/Engine/Source/Programs/AutomationTool/Scripts/BuildPluginCommand.Automation.cs)