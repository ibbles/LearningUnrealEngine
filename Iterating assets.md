2021-05-11_16:14:05

# Iterating assets

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