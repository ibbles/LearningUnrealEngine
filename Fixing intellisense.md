# Fixing intellisense

A bug introduced in Unreal Engine 4.25 broke IDE, e.g. CLion, integration intellisense code model project generation auto complete syntax highlighting, causing red error marks to appear everywhere in the code.

Someone has prepared engine source fixes patch patches for it:
- 4.25: https://gist.github.com/ericwomer/142650e65473087073f30e5fb97fd6e8 
- 4.26: https://gist.github.com/jerobarraco/92839db6e6305fb04a04bab415ec8ae4
- 4.27: https://gist.github.com/aknarts/7d7367fa5e5e54fe30be3bd6b67cf59d

(
The above changes used to work, but now they don't anymore.
Not sure what changed.
CLion 2021.2.4
)

In short, the problem is in `Engine/Source/Programs/UnrealBuildTool/Configuration/UEBuildModuleCPP.cs` and the cause is that `CompileEnvironment.Definitions` is cleared too early.

Symptoms include Unreal Engine macros not being recognized, missing class definitions, undeclared definitions, auto-complete not working, parameter hints not working, and so on.

## Unreal Engine 4.25

```diff
⎇  4.25.3-release➤ git diff Engine/Source/Programs/UnrealBuildTool/Configuration/UEBuildModuleCPP.cs
diff --git a/Engine/Source/Programs/UnrealBuildTool/Configuration/UEBuildModuleCPP.cs b/Engine/Source/Programs/UnrealBuildTool/Configuration/UEBuildModuleCPP.cs
index 4c0428ad373..b07fbd97fcc 100644
--- a/Engine/Source/Programs/UnrealBuildTool/Configuration/UEBuildModuleCPP.cs
+++ b/Engine/Source/Programs/UnrealBuildTool/Configuration/UEBuildModuleCPP.cs
@@ -404,6 +404,10 @@ namespace UnrealBuildTool

                        // Write all the definitions to a separate file
                        CreateHeaderForDefinitions(CompileEnvironment, IntermediateDirectory, null, Graph);
+            if (CompileEnvironment.Definitions.Count > 0)
+            {
+                CompileEnvironment.Definitions.Clear();
+            }

                        // Mapping of source file to unity file. We output this to intermediate directories for other tools (eg. live coding) to use.
                        Dictionary<FileItem, FileItem> SourceFileToUnityFile = new Dictionary<FileItem, FileItem>();
@@ -874,6 +878,10 @@ namespace UnrealBuildTool
                {
                        // Write all the definitions out to a separate file
                        CreateHeaderForDefinitions(CompileEnvironment, IntermediateDirectory, "Adaptive", Graph);
+            if (CompileEnvironment.Definitions.Count > 0)
+            {
+                CompileEnvironment.Definitions.Clear();
+            }

                        // Compile the files
                        return ToolChain.CompileCPPFiles(CompileEnvironment, Files, IntermediateDirectory, ModuleName, Graph);
@@ -886,6 +894,10 @@ namespace UnrealBuildTool

                        // Write all the definitions out to a separate file
                        CreateHeaderForDefinitions(CompileEnvironment, IntermediateDirectory, "Adaptive", Graph);
+            if (CompileEnvironment.Definitions.Count > 0)
+            {
+                CompileEnvironment.Definitions.Clear();
+            }

                        // Compile the files
                        return ToolChain.CompileCPPFiles(CompileEnvironment, Files, IntermediateDirectory, ModuleName, Graph);
@@ -1001,7 +1013,7 @@ namespace UnrealBuildTool
                                                }

                                                CompileEnvironment = new CppCompileEnvironment(CompileEnvironment);
-                                               CompileEnvironment.Definitions.Clear();
+                                               // CompileEnvironment.Definitions.Clear(); // @todo: Do not clear definitions prior to end of their usefulness
                                                CompileEnvironment.ForceIncludeFiles.Add(PrivateDefinitionsFileItem);
                                                CompileEnvironment.PrecompiledHeaderAction = PrecompiledHeaderAction.Include;
                                                CompileEnvironment.PrecompiledHeaderIncludeFilename = Instance.HeaderFile.Location;
@@ -1039,7 +1051,7 @@ namespace UnrealBuildTool
                                using (StringWriter Writer = new StringWriter())
                                {
                                        WriteDefinitions(CompileEnvironment.Definitions, Writer);
-                                       CompileEnvironment.Definitions.Clear();
+                                       // CompileEnvironment.Definitions.Clear(); // @todo: Do not clear definitions prior to end of their usefulness

                                        FileItem PrivateDefinitionsFileItem = Graph.CreateIntermediateTextFile(PrivateDefinitionsFile, Writer.ToString());
                                        CompileEnvironment.ForceIncludeFiles.Add(PrivateDefinitionsFileItem);
                                                                                                                                      [ 0s024 ]


```
