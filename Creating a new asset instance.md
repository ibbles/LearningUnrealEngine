2021-02-18_09:48:24

# Creating a new asset instance

How to create and save a new asset instance to disk.

```cpp
T& Source; // Some data we get from somewhere.
FString DirectoryName = TEXT("MyDirectory");
FString AssetName = TEXT("MyAsset");

DirectoryName = UPackageTools::SanitizePackageName(DirectoryName);
AssetName = UpackageTools::SanitizePackageName(AssetName);

FString PackagePath = FString::Printf(TEXT("/Game/%s/"), *DirectoryName);

IAssetTools& AssetTools =
    FModuleManager::LoadModuleChecked<FAssetToolsModule>("AssetTools").get();
AssetTools.CreateUniqueAssetName(PackagePath, AssetName, PackagePath, AssetName);
// PackagePath and AssetName may now have been changed.

// Create the package at /Game/MyDirectory/.
UPackage* Package = CreatePackage(nullptr, *PackagePath);
Package->FullyLoad(); // Not sure if/when this is needed.

UMyAsset* Asset =
    NewObject<UAsset>(Package, FName(*AssetName), RF_Public | RF_Standalone);

// Do any asset-specific initialization. This can be anything.
Asset->InitFrom(Source);

FAssetRegistryModule::AssetCreated(Asset);
Asset->MarkPackageDirty();
Asset->PostEditChange();
Asset->AddToRoot();
Package->SetDirtyFlag(true);

const FString PackageFilename = FPackageName::LongPackageNameToFilename(
    PackagePath, FPackageName::GetAssetPackageExtension());

Package->GetMetaData();

UPackage::SavePackage(Package, Asset, RF_NoFlags, *PackageFilename);
```


```cpp
// I'm a bit unclear on what each name and path should be at each stage of the
// process. The double-name-with-dot schenanigans is still confusing to me.
FString AssetName = TEXT("MyAsset");
FString PackagePath = TEXT("/Game/MyFolder/");

IAssetTools& AssetTools =
        FModuleManager::LoadModuleChecked<FAssetToolsModule>("AssetTools").Get();
AssetTools.CreateUniqueAssetName(PackagePath, AssetName, PackagePath, AssetName);

// Asset name may now be something other than what we set it to previously,
// if there already was an asset there with the same name.
// There is FPackageTools::SanitizePackageName that can be used somewhere around
// here. Not sure what should be passed to it.

UPackage* Package = CreatePackage(nullptr, *PackagePath);

Package->FullyLoad(); // Not sure if this line is needed or not.

UMyAsset* Asset =
    NewObject<UMyAsset>(Package, FName(*AssetName), RF_Public | RF_Standalaone);

// Do whatever initialization of Asset that you may want. Setting values for
// its properties and so on.

FAssetRegistryModule::AssetCreated(Asset);
Asset->MarkPackageDirty();
Asset->PostEditChange();
Asset->AddToRoot();
Package->SetDirtyFlag(true);

const FString PackageFilename = FPackageName::LongPackageNameToFilename(
    PackagePath, FPackageName::GetAssetPackageExtension());

Package->GetMetaData();
UPackage::SavePackge(Package, Asset, RF_NoFlags, *PackageFilename);
```

[[2020-10-03_10:38:42]] [Creating new asset types](./Creating%20new%20asset%20types.md)  