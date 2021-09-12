2020-03-11_19:00:31

# Assets
Static meshes and textures are examples of assets.

Assets are loaded into C++ differently depending on if the load happens in a `UObject` constructor or not.
(
Different how?
)

Assets are found in the Content Browser.
Each folder in the Content Browser maps to a directory on the file system.
Directories are picked up from:
- The project's Content directory.
- Unreal Engine's Content directory.
- Any loaded plugin's Content directory.
- Directories registered with `FPackageName::RegisterMountPoint`
- Directories registered with `UContentBrowserDataSource`/`ContentBrowserAssetDataSource`.


`ContentBrowserDataSource` seems to be newer than `FPackageName::RegisterMountPoint`.
I don't see it in my 4.25 installation.

Official documentation: [https://docs.unrealengine.com/en-US/Programming/Assets/ReferencingAssets/index.html](https://docs.unrealengine.com/en-US/Programming/Assets/ReferencingAssets/index.html)

There are two helpers for asset management: Asset Registry and Asset Manager.
The Asset Registry is the lower-level system that drives pretty much everything asset-related.
The Asset Manager is built on top of the Asset Registry.
The Asset Registry is always available, the Asset Manager might be an Editor-only thing.


[[2021-05-11_16:14:05]] [Iterating assets](./Iterating%20assets.md)  