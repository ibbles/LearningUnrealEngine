2021-07-09_09:54:02

# Build ID

Unreal Engine creates a Build ID for each build.
The Build ID prevents dynamic libraries from being used with the wrong build of the engine.
The purpose is to prevent stale and outdated dynamic libraries from being accidentally loaded, which is a common source of difficult-to-diagnose problems.
At build time a `.modules` JSON file is written to each output directory that has at least one compiled dynamic library.
This files lists the modules, their associated dynamic library, and the Build ID for the current build.
The `.modules` files should be included in binary releases of the engine.

All modules must have the same Build ID.
If any module has the wrong Build ID then the editor try to rebuild the module and if that fails the editor it closed.
```
LogInit: Warning: Incompatible or missing module
```

The Build IDs in a folder, either the engine or a project, can be printed with
```bash
find <DIRECTORY> -name "*.modules" -exec grep "BuildId" '{}' '+' | awk '{print $3 " " $1}' | sort
```
