2020-08-17_09:45:29

# Loading assets

In an Actor or Component constructor (possibly other classes as well), an asset should be loaded with

```c++
#include "UObject/ConstructorHelpers.h"

MyClass::MyClass()
{
	static ConstructorHelpers::FObjectFinder<UMyAsset> Finder(
        TEXT("/Game/<Folder>/<AssetName>"));
	UMyAsset* MyAsset =
			Finder.Succeeded()
				? Cast<UMyAsset>(Finder.Object)
				: <fallback or nullptr>;
}
```

It is common that the target, `MyAsset` in the above example, is a member `UPROPERTY` and not a local variable.


Outside of a constructor we're not allowed to use `ConstructorHelpers`.
Instead use `StaticLoadObject`:

```c++
const TCHAR* AssetPath =
			TEXT("<Type>'/Game/Folder/<Name>.<Name>'");
UObject* LoadResult = StaticLoadObject(
    UMyAsset::StaticClass(), nullptr, AssetPath);
if (LoadResult == nullptr)
{
	// Error: The asset does not exist.
	return;
}
UType* Asset = Cast<UType>(LoadResult);
if (Asset == nullptr)
{
	// Error: The asset wasn't of the correct type.
    // Not sure if this can happen when including the '<Type>' part
    // of the asset path. But that part is optional, so just in case.
    return;
}
// Safe to use Asset here.
```

There is also `LoadObject`, which is a simple wrapper around `StaticLoadObject` that does the cast and removes the `bAllowObjectReconciliation` flag.

Notice that the `Name` part of the path is given twice. I'm not sure why.
There is something called `FPackageGroupName` that may relate to this.


There is also `FStringAssetReference` which should be used when loading assets.
It holds the path to the asset and has a `TryLoad` member function to get a reference to the asset itself.
Not sure how `StaticLoadObject` and `FStringAssetReference.TryLoad` relate to each other.

There is also something about dependency on `LoadPackage` and limitations on cooked data, servers, and `GUseSeekFreeLoading` that I don't understand yet.