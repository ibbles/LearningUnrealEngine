2021-05-11_16:14:05

# Iterating assets


Not sure what this is:
```cpp
TArray<FAssetData> AssetList;
AssetRegistry.GetAssets(Filter, AssetList);
for(FAssetData const& Asset : AssetList)
{
    if (UBlueprint* BP = Cast<UBlueprint>(Asset.GetAsset()))
    {
        /// @todo I thing this example is supposed to have more code.
    }
}
```


Not sure what this is:
```cpp
FAssetRegistryModule& AssetRegistryModule =
    FModuleManager::LoadModuleChcked<FAssetRegistryModule>(TEXT("AssetRegistry"));
IAssetRegistry& AssetRegistry = AssetRegistryModule.Get();

TArray<FString> ContentPaths;
ContentPaths.Add(TEXT("/Game/MyFolder"));
AssetRegistry.ScanPathsSynchronous(ContentPaths);

TSet<FName> DerivedNames;
{
    TArray<FName> BaseNames;
    BaseNames.Add(UMyClass::StaticClass()->GetFName());

    TSet<FName> Excluded;
    AssetRegistry.GetDerivedClassNames(BaseNames, Excluded, DerivedNames);
}

FARFilter Filter;
Filter.ClassNames.Add(UBlueprint::StaticClass()->GetFName());
Filter.bRecursiveClasses = true;
Filter.bRecursivePaths = true;

TArray<FAssetData> AssetList;
AssetRegistry.GetAssets(Filter, AssetList);
```

Getting dependencies for an asset:
```cpp
FAssetRegistryModule& AssetRegistryModule = FModuleManager::LoadModuleChecked<FAssetRegistryModule>("AssetRegistry");

FARFilter Filter;
Filter.ClassNames.Add(UBlueprint::StaticClass()->GetFName());
Filter.bRecursiveClasses = true;

TArray<FAssetData> AssetData;
AssetRegistryModule.Get().GetAssets(Filter, AssetData);

for (FAssetData Asset : AssetData)
{
    TArray<FName> FoundDependencies;
    AssetRegistryModule.Get().GetDependencies(Asset.PackageName, FoundDependencies);
    for (FName Dependency : FoundDependencies)
    {
        UE_LOG(LogTemp, Display, TEXT("MyEditorUtilityActor::33 - %s"), *Dependency.ToString());
    }
}
```

[[2020-03-11_19:00:31]] [Assets](./Assets.md)  
