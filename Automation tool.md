2020-08-27_20:25:41

# Automation Tool

A program used for automating Unreal Engine related tasks such as building, cooking, packaging, automation tests, …
Not for doing stuff inside the editor. Use Editor Scripting for that.
Automation tasks are written in C#.
Automation tasks are stored in `.Automation.csproj` projects.
Automation tasks are implemented as classes deriving from `BuildCommand`.
Automation tasks are run from the command line, from the `Engine/Build/BatchFiles` directory.
Run the task with `./RunUAT.sh <COMMAND>` where `<COMMAND>` is the name of the class inheriting from `BuildCommand`.
Arguments can be passed to the command by adding `-<PARAMETER>` after the name.
Multiple commands can be queued from the same command line.
Parameters bind to the closest command to the left.
`./RunUAT.sh Command1 -Arg1 -Arg2 Command2 -Arg1 -Arg2`
Global options:
- `-Help`: Print help either for the command the parameter is passed to, or for AutomationTool in general if there is no command to the left of `-Help`.
- `-List`: List the available commands.
- `-Submit`: Allow file submit. No idea what this means. Submit to version control? To a build process? To some server somewhere?
- `-NoCompile`: Disable compilation of `.Automation.csproj` projects on startup.

Project-specific tasks can be created by placing a C# project where Automation Tool can find it.

