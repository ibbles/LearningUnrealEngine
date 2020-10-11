2020-10-03_10:38:42

# Creating new asset types
Steps to create a new asset type:
- Declare the asset type's C++ class.
- Implement asset factories.
- Customize asset appearance in Unreal Editor.
- Customize asset editor UI.
- Add asset-specific Content Browser actions.


The asset's C++ class define the content of the asset.
The class should inherit from `UObject`.
The class should be marked with the `*_API` macro for the module it's in.
The class should be marked with the `UCLASS` macro.
Need the following headers: `"CoreMinimal.h"` `"UObject/Object.h"`, `"UObject/ObjectMacros.h"`.
As with all generated classes, also need `"<CLASS_NAME>.generated.h"` last in the include list.
Non-static data members that form the salient properties of the asset should be marked with `UPROPERTY`.

New asset types can be created by plugins. 

## Factories
Factories are used when creating instances of the asset type.
Factories are editor concepts and should be in an editor module. [[2020-09-15_21:10:32]] [Module types](./Module%20types.md)
Factories are C++ classes.
Inherits from `UFactory`.
`UFactory` provides virtual functions to be overridden.
The main forms of integrations with the editor already implemented, need only provide the asset-specific details in the virtual functions.
There are three types of factories:
- `<ASSET_NAME>FactoryNew`: When creating asset from the Content Browser right-click menu.
- `<ASSET_NAME>Factory`: When a file is being drag-and-dropped into the Content Browser.
- `Reimport<ASSET_NAME>Factory`: Recreate assets when files on disk changed. Can be part of `<ASSET_NAME>Factory` instead.

Three types only for historical reasons. May be modernized in the future so that only a single factory class is required.

Example `MyAssetFactoryNew`, a factory that creates `MyAsset` instances from the Content Browser right-click menu.

`MyAssetFactoryNew.h`:
```c++
UCLASS()
class YMyAssetFactoryNew : public UFactory
{
    GENERATED_UCLASS_BODY()
public:
    //~ UFactory Interface
    virtual UObject* FactoryCreateNew(UClass* InClass, UObject* InParent, FName InName, ...
    virtual bool ShouldShowInNewMenu*() const override;
}
```

`MyAssetFactoryNew.cpp`:
```c++
UMyAssetFactoryNew::UMyAssetFactoryNew(const FObjectInitializer& ObjectInitializer)
    : Super(ObjectInitializer)
{
    // Tell the editor which type of assets this factor can
    // create.
    SupportedClass = UMyAsset::StaticClass();

    // This factory creates new instances from scratch
    // rather than importing using drag-and-drop. This is
    // what decide which of the tree factory types this
    // factory is. How we can get three types from a bool is
    // beyond me.
    bCreateNew = true;

    // Enter name-edit-mode after the asset has been created.
    bEditAfterNew = true;
}

// Called by the engine when a new instance of the asset
// type is to be created. That is, when the  user has
// right-clicked in the Content Browser and selected MyAsset
// from the list.
UObject* UMyAssetFactoryNew::FactoryCreateNew(UClass* InClass, UObject* InParent, FName, ...
{
    return NewObject<UMyAsset>(InParent, InClass, InName, Flags);
}

// Return true to make the MyAsset asset show up in the Content Browser context menu.
bool UMyAssetFactoryNew::ShouldShowInNewMenu() const
{
    return true;
}
```

Example `MyAssetFactoryNew`, a factory that creates `MyAsset` instances from the Content Browser right-click menu.




## Editor customization

By default the asset editor is generated automatically in the same way as the Details Panel.
This can be customized.
The Blueprint and Material editor are examples of custom asset editors.
The asset can have custom color, text, and icon in the Content Browser.
The icon can be any UI widget, including a 3D viewport.
Look into `UThimbnailRenderer`.

Asset Action are used to customize the look and feel of assets in the Editor, and to provide custom actions that can be performed on the assets.
Custom editor actions on assets are created by inheriting from `FAssetTypeActions_Base`.
`FAssetTypeActions_Base` is a helper class, one can also inherit from the `IAssetTypeActions` interface.
The actual action is registered/implemented in `FTextAssetActions::GetActions`.
The implementation can be a lambda callback.
The action must be registered with the Editor.
This is often done in the module's `IModuleInterface` implementation, which is in `<MODULE_NAME>Module.cpp`.

To register an asset tool, load the `AssetTools` module and call `RegisterAssetTypeAction`.
The `AssetTools` module maintains a registry of of all the asset tools.
Use `RegisterAssetTypeAction`, passing in the `AssetTools` and a new instance of the `IAssetTypeActions` subclass.
```c++
virtual void StartupModule() override
{
    Style = MakeShareable(new FMyAssetEditorStyle());
    IAssetTools& AssetTools = 
        ModuleManager::LoadModuleChecked<FAssetToolsModule>(
            "AssetTools").Get();
    RegisterAssetTypeActions(AssetTools, MakeShareable(new FMyAssetActions(Style.ToSharedRef())));
}
```
Not sure what the `Style` is.


[[2020-09-10_19:55:50]] [Modules](./Modules.md)  
[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  
[[2020-08-31_10:01:57]] [Garbage collection](./Garbage%20collection.md)  



[[2020-03-11_19:00:31]] [Assets](./Assets.md)  
[[2020-08-17_09:45:29]] [Loading assets](./Loading%20assets.md)  
[[2020-03-10_21:23:32]] [Naming convention](./Naming%20convention.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
