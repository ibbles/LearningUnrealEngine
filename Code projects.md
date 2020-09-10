2020-09-10_19:42:18

# Code projects

Also called C++ projects.
The alternative to pure Blueprint projects.
Code projects can also contain Blueprints.
Create a new code project by starting Unreal Editor without passing a project.
The New Project dialog is shown.
Select the C++ tab and then any of the templates.
Will create and compile some boilerplate code in the new project.
Created directories:
- Binaires  
    The compiled binaries. Each module in the Source directory will become a dynamically linked library here.
- Config  
    Configuration files and settings for the editor, the engine, and the game.
- Content  
    Content you create for the project. Possibly also Starter Content.
- Intermediate  
    Temporary working files for the build process. Can safely be deleted at any time, except while compiling, will be recreated when needed.
- Saved  
    Configuration files created by the editor or the game at runtime. And log files.
- Source  
    Contains the source code for the modules in the project.
Created files:
- `.uproject`  
    JSON text filesle

While working on a code project you will use a C++ IDE or editor to edit the code and Unreal Editor to edit Blueprints and levels.

Unreal Engine support Hot Reload, i.e., to recompile the C++ code while Unreal Editor is open.
THIS IS A VERY BAD IDEA!
It rarely works and can lead to asset and Blueprint corruption.
Use Live Coding instead, if you're on Windows. Close Unreal Editor while compiling if on any other platform.

[[2020-09-10_19:55:50]] [Modules](./Modules.md)