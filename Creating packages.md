2020-08-06_18:04:32

# Creating packages

A Package is a file on disk that stores a game object.
They have the `.uasset` suffix.

This is just a quick summary, not the only/best/correct way to do it:

```c++
// Create the package.
UPackage* Package = CreatePackage(nullptr, *PackageName);
Package->FullyLoad();

// Create an object in the package
UArmourVisualData* NewAsset = NewObject<UArmourVisualData>(
    Package, UArmourVisualData::StaticClass(), *MatchName,
    EObjectFlags::RF_Public | EObjectFlags::RF_Standalone | EObjectFlags::RF_MarkAsRootSet);

// Configure the object, if necessary.

// Finalize, where CreatedAssets is an array with all the created assets.
FAssetRegistryModule::AssetCreated(NewAsset);
Package->MarkPackageDirty();
UPackageTools::SavePackagesForObjects(CreatedAssets);
```

Discussion from Unreal Slackers Discord:

> what does the markasrootset flag do here specifically? For asset creation you only need Public and Standalone as flags

> I think the markasrootset makes sure it is not immediately garbage collected 
> idk though, I based this of off some stuff I found online as well
> and it seemed to work for me
> ¯\\_(ツ)_/¯

> thats what the standalone flag is for. I think the markasrootset is for UObjects that arent assets

