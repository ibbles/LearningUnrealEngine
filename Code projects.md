2020-09-10_19:42:18

# Code projects

Also called C++ projects.
The alternative to pure Blueprint projects.
Code projects can also contain Blueprints.
Create a new code project by starting Unreal Editor without passing a project.
The New Project dialog is shown.
Select the C++ tab and then any of the templates.
The way the new project wizard is structured was changed somewhere around 4.24.
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
    Contains the source code for the modules in the project. A collection of `.h` and `.cpp` files organized into modules.
Created files:
- `.uproject`
    - JSON text filesle
- `Source/` `.h`/`.cpp`
    - Source files that implement the functionality of the project, i.e. declarations and implementations of functions and types. Each source file is placed within a module directory.

Code projects contain `Target.cs` files that relate to but are separate from the modules' `Build.cs` files.
I havne't fully understood their relationship yet.

While working on a code project you will use a C++ IDE or editor to edit the code and Unreal Editor to edit Blueprints and levels.


Unreal Engine support Hot Reload, i.e., to recompile the C++ code while Unreal Editor is open.
THIS IS A VERY BAD IDEA!
It rarely works and can lead to asset and Blueprint corruption.
Use Live Coding instead, if you're on Windows. Close Unreal Editor while compiling if on any other platform.

[[2020-09-10_19:55:50]] [Modules](./Modules.md)  
[[2020-09-11_13:11:21]] [Target](./Target.md)  
[[2020-09-15_17:27:33]] [Plugins](./Plugins.md)  
[[2020-09-15_18:48:29]] [Building a C++ project](./Building%20a%20C++%20project.md)  