## Fixing intellisense

A bug introduced in Unreal Engine 4.25 broke IDE, e.g. CLion, integration intellisense code model project generation auto complete syntax highlighting, causing red error marks to appear everywhere in the code.

Someone has prepared engine source fixes patch patches for it:
- 4.25: https://gist.github.com/ericwomer/142650e65473087073f30e5fb97fd6e8 
- 4.26: https://gist.github.com/jerobarraco/92839db6e6305fb04a04bab415ec8ae4  

In short, the problem is in `Engine/Source/Programs/UnrealBuildTool/Configuration/UEBuildModuleCPP.cs` and the cause is that `CompileEnvironment.Definitions` is cleared too early.

Symptoms include Unreal Engine macros not being recognized, missing class definitions, undeclared definitions, auto-complete not working, parameter hints not working, and so on.
