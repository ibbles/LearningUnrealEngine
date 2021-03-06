2021-01-28_14:36:46

# Redirects and redirectors

A redirector is an object that references, to an asset for example, can point to that will forward the reference to a new target.
They are used when an asset is moved so that references to the old location will find the asset at the new location.
Redirectors are created automatically at the old location when an asset is moved or renamed with the Content Browser.
The Content Browser folder context menu contains Fix Up Redirectors in Folder.
Fix Up Redirectors searches for references that point to a redirector and makes all reference point to the new location instead, then the redirectors are removed.

We can add Core Redirects to a project's `DefaultEngine.ini`.
They look something along the lines of
```
[CoreRedirects]
+PackageRedirects=(OldName="/MyOldPlugin", NewName="/MyNewPlugin", MatchSubstring=true)
+ClassRedirects=(OldName="/Script/MyOldPlugin.", NewName="/Script/MyNewPlugin.", MatchSubstring=true)
+StructRedirects=(OldName="/Script/MyOldPlugin.", NewName="/Script/MyNewPlugin.", MatchSubstring=true)
```

Blueprint Interfaces (maybe Interfaces in general) are a bit special.
```
ClassRedirects=(OldName="BPI_MyInterface_C", NewName="/Script/MyPlugin.MyInterface", OverrideClassName="/Script/CoreUObject.Class")
```
I don't understand one bit of this.

[Redirectors @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProductionPipelines/Redirectors/index.html)  
[CoreRedirects @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProgrammingAndScripting/ProgrammingWithCPP/Assets/CoreRedirects/index.html)  
[UEngine @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/API/Runtime/Engine/Engine/UEngine/index.html)  

[How can I rename a plugin and not break all blueprints? @ answers.unrealengine.com](https://answers.unrealengine.com/questions/355744/view.html)  
[Renaming a C++ project @ answers.unrealengine.com](https://answers.unrealengine.com/questions/242407/renaming-a-c-project.html)  
