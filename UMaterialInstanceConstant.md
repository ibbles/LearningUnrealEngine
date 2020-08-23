2020-08-11_13:53:42

# UMaterialInstanceConstant

A new Material Instance is created with the following code, taken from the 2016 version of `FAssetTypeActions_MaterialInterface::ExecuteNewMic`.
[https://forums.unrealengine.com/development-discussion/c-gameplay-programming/98655-create-a-material-instance](https://forums.unrealengine.com/development-discussion/c-gameplay-programming/98655-create-a-material-instance) (2016)

```c++
UMaterialInterface* ParentMaterial = ...;

// Create an appropriate and unique name.
FString Name;
FString PackageName;
CreateUniqueAssetName(
    ParentMaterial->GetOutermost()->GetName(),
    DefaultSuffix, PackageName, Name);

UMaterialInstanceConstantFactoryNew* Factory =
    NewObject<UMaterialInstanceConstantFactoryNew>();
Factory->InitialParent = ParentMaterial;
    
FContentBrowserModule& ContentBrowserModule =
    FModuleManager::LoadModuleChecked<FContentBrowserModule>(
        "ContentBrowser");
ContentBrowserModule.Get().CreateNewAsset(
    Name, FPackageName::GetLongPackagePath(PackageName),
    UMaterialInstanceConstant::StaticClass(), Factory);
```

The list of parameters provided by the parent material is found by calling `GetStaticParameterValues` on the Material Instance.

The FBX importer may do something similar to what we want to do.
At least according to [https://github.com/gildor2/UEViewer/issues/118](https://github.com/gildor2/UEViewer/issues/118) (2019).
Check `Engine/Source/Editor/UnrealEd/Private/Fbx/FbxMaterialImport.cpp`.
`UnFbx::FFbxImporter::CreateUnrealMaterial`.

Example code from the gildor2 issue:
```c++
// Let's assume 'Template' is UMaterial which will be instantiated.

UMaterial* Template = ...;
UMaterialInstanceConstantFactoryNew* MaterialFactory =
    NewObject<UMaterialInstanceConstantFactoryNew>();
MaterialFactory->InitialParent = Template;
    
FAssetToolsModule &AssetToolsModule =
    FModuleManager::Get().LoadModuleChecked<FAssetToolsModule>(
        "AssetTools");
UObject* Asset = AssetToolsModule.Get().CreateAsset(
    InstanceName, FPackageName::GetLongPackagePath(PackagePath),
    UMaterialInstanceConstant::StaticClass(), MaterialFactory);

// Now you'll have 'Asset' which could be casted to UMaterialInstanceConstant.

UMaterialInstanceConstant* mat = Cast<UMaterialInstanceConstant>(Asset);

// Then use UMaterialInstanceConstant's methods:
// * SetTextureParameterValueEditorOnly
// * SetVectorParameterValueEditorOnly
// * SetScalarParameterValueEditorOnly

// Then, when finished, call this on material instance:
mat->SetFlags(RF_Standalone);
mat->MarkPackageDirty();
mat->PostEditChange();
```

The two example implementations are very similar.
One difference is that one uses the ContentBrowserModule while the other uses the AssetToolsModule.
I don't know what the difference is, or if one has been deprecated in favour of the other.


Yet another version, this one from 2016.
[https://stackoverflow.com/questions/37960045/unreal-engine-4-c-change-staticmeshcomponent-of-astaticmeshactor](https://stackoverflow.com/questions/37960045/unreal-engine-4-c-change-staticmeshcomponent-of-astaticmeshactor)
The goal of this code is to change the material of some Actor.

```c++
//Find Actor and change Material
AStaticMeshActor* Actor = ...;

// Material Path.
FString matPath = 
    "Material'/Game/StarterContent/Materials/M_Metal_Gold.M_Metal_Gold'";
// Material Instance.
UMaterialInstanceConstant* material = 
    Cast<UMaterialInstanceConstant>(
    	StaticLoadObject(
        	UMaterialInstanceConstant::StaticClass(),
            nullptr,
            *matPath));

TArray<UStaticMeshComponent*> MaterialComps;
Actor->GetComponents(MaterialComps);
for (int32 Index = 0; Index != MaterialComps.Num(); ++Index)
{
	UStaticMeshComponent* targetComp = MaterialComps[Index];
    int32 mCnt = targetComp->GetNumMaterials();
    for (int i = 0; i < mCnt; i++)
    {
        targetComp->SetMaterial(0, material);
    }
}
```

This one uses `StaticLoadObject` to get the `UMaterialInstanceConstant`.
So a new one is not created, we re-use one that already exists.
Can `StaticLoadObject` be used outside of constructors?
Can `StaticLoadObject` be used during Play?
Think it's "yes" to both of these. The documentation doesn't forbid it, at least.