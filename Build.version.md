2022-03-16_12:06:49

# Build.version

The Unreal Engine directory contains `UE_ROOT/Engine/Build/Build.version`.
This file contains a bunch of version information about the current version.
It should contain a value for `Changelist`, but git working copies doesn't.
It is still possible to build and use Unreal Engine, but it is incompatible with the official Windows Unreal Engine binaries downloaded by the Epic Games Launcher.
The problem is that assets saved with the git version won't write a valid engine version to the asset files.
This causes the Windows Unreal Editor to write a warning for each asset.
```
Asset saved with empty engine version
```

By setting `Changelist` in `UE_ROOT/Engine/Build/Build.version` to the same value as the official Unreal Engine binaries we fix this warning.

- Unreal Engine 4.25: 14469661
- Unreal Engine 4.26: 15973114
- Unreal Engine 4.27: 18319896
