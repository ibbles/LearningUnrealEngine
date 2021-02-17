2020-10-03_10:38:42

# Creating new asset types
New asset types can be created by plugins. 
Steps to create a new asset type:
- Declare the asset type's C++ class.
- Implement asset factories.
- Customize asset appearance in Content Browser.
- Customize asset editor UI.
- Add asset-specific Content Browser actions.

The asset's C++ class define the content of the asset.
The class should inherit from `UObject`.
There may be other non-Unreal Engine classes between `UObject` and the asset class.
The class should be marked with the `*_API` macro for the module it's in.
The class should be marked with the `UCLASS` macro.
Need the following headers: `"CoreMinimal.h"`, `"UObject/Object.h"`, `"UObject/ObjectMacros.h"`.
As with all generated classes, also need `"<CLASS_NAME>.generated.h"` last in the include list.
Non-static data members that form the salient properties of the asset should be marked with `UPROPERTY`.

```cpp
#pragma once

#include "UObject/Object.h"
#include "MyAsset.generated.h"

UCLASS(BlueprintType)
class MYMODULE_API UMyAsset : public UObject
{
    GENERATED_BODY()
public:
    UPROPERTY(VisibleEverywhere, BlueprintReadOnly)
    float MyFloat;
}
```

One can bypass all the factory stuff described below by having the asset type derive from `UDataAsset` instead of `UObject`.
Then the asset type will show up in the Content Browser > Context Menu > Miscellaneous > Data Asset list.
By default these assets get the standard property editor, but can have a custom editor i.e, a Detail Customization.

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
class UMyAssetFactoryNew : public UFactory
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
    // what decide which of the three factory types this
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
    check(Class->IsChildOf(UMyAsset::StaticClass()));
    return NewObject<UMyAsset>(InParent, InClass, InName, Flags);
}

// Return true to make the MyAsset asset show up in the Content Browser context menu.
bool UMyAssetFactoryNew::ShouldShowInNewMenu() const
{
    return true;
}
```

Example `MyAssetFactoryNew`, a factory that creates `MyAsset` instances from the Content Browser right-click menu.


There is also `UActorFactory`, which is used when an asset is dragged from the Content Browser into the Level Viewport.

There is also `IComponentAssetBroker`, which is used when an asset is dragged from the Content Browser into the Components Panel of a Blueprint class.

## Editor customization

The asset can have custom color, text, and icon in the Content Browser.
The icon can be any UI widget, including a 3D viewport.
Look into `UThumbnailRenderer`.

Asset Action are used to customize the look and feel of assets in the Editor, and to provide custom actions that can be performed on the assets.
Custom editor actions on assets are created by inheriting from `FAssetTypeActions_Base`.
`FAssetTypeActions_Base` is a helper class, one can also inherit from the `IAssetTypeActions` interface.
The actual action is registered/implemented in `IAssetTypeActions::GetActions`.
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
    RegisterAssetTypeActions(
        AssetTools, MakeShareable(new FMyAssetActions(Style.ToSharedRef())));
}
```
Not sure what the `Style` is.
Not sure where in the Unreal Editor UI this shows up.

Another variant is to register an Advanced Asset Category.
Then a collection of Asset Actions can be collected in a submenu of the Content Browser context menu.
```cpp
virtual void StartupModule() override
{
	IAssetTools& AssetTools =
		FModuleManager::LoadModuleChecked<FAssetToolsModule>("AssetTools").Get();

	EAssetTypeCategories::Type MyAssetCategoryBit =
        AssetTools.RegisterAdvancedAssetCategory(
        	FName(TEXT("MyCategoryName")),
            LOCTEXT("MyCategoryLabel", "MyCategoryLabel"));
    
    // Repeat for each IAssetTypeActions class.
    TSharedPtr<IAssetTypeActions> MyAssetActions =
        MakeShareable(new FMyAssetActions(MyAssetCategoryBit));
    AssetTools.RegisterAssetTypeActions(MyAssetActions.ToSharedRef());
}
```

By default the asset editor is generated automatically in the same way as the Details Panel.
This can be customized.
The Blueprint and Material editors are examples of custom asset editors.

We need two classes:
- `FMyAssetActions : IAssetTypeActions`: To create the new editor when needed.
- `FMyAssetEditor : FAssedEditorToolkit, FEditorUndoClient, FGCObject`: The asset editor.
Both classes should be in the Editor module of the plugin

To provide a custom asset editor override `OpenAssetEditor` in your `IAssetTypeActions` subclass.
"Toolkit" is a synonym for Asset Editor. 
Toolkit often used within the code, for type names and such.
Asset Editor is often used within documentation and articles.
```
void OpenAssetEditor(
    const TArray<UObject*>& InObjects,
    TSharedPtr<IToolkitHost> EditWithinLevelEditor)
```
- `InObjects`: The objects being edited. Can be multiple since multiple objects can be selected in the Content Browser. Loop over these and use `Cast` to determine if it's a type of object supported .
- `EditWithinLevelEditor`: Passed on to the `EditorToolkit` instances we create.

For each object, create and initialize a new `FMyAssetEditorToolkit`:
```
TSharedRef<FTextAssetEditorToolkit> EditorToolkit = MakeShareable(
    new FMyAssetEditorToolkit(Style));
   
EditorToolkit->Initialize(MyAsset, Mode, EditWithinLevelEditor);
```

`Style` is the one that was created in `StartupModule`.
`MyAsset` is the `Cast`ed object we got form `InObjects`.
`Mode` either `WorldCentric` or `Standalone` depending on if `EditWithinLevelEditor` is valid.

Full example:
```
void FMyAssetActions: OpenAssetEditor(
    const TArray<UObject*>& InObjects,
    TSharedPtr<IToolkitHost> EditWithinLevelEditor)
{
    EToolkitMode::Type Mode = EditWithinLevelEditor.IsValid()
        ? EToolkiMode::WorldCentric
        : EToolkitMode::Standalone;
    for (auto ObjIt = InObjects.CreateConstIterator(); ObjIt; ++ObjIt)
    {
        UMyAsset* MyAsset = Cast<UMyAsset(*ObjIt);
        if (MyAsset == nullptr)
        {
            continue;
        }
        TSharedRef<FTextAssetEditorToolkit> EditorToolkit = MakeShareable(
            new FMyAssetEditorToolkit(Style));
        EditorToolkit->Initialize(MyAsset, Mode, EditWithinLevelEditor);
    }
}
```

The call to `Initialize` will cause the asset editor to show up.

The `FMyAssetEditor` class is much larger. Too large to describe in detail here.
See [TextAsset@github.com](https://github.com/ue4plugins/TextAsset) for the full code.
In short, the editor is built inside a `Layout` where a big expression is used to create the splits that the editor window is divided into.
This is where the layout of the tabs is declared.

A collection of tabs that share an area on the screen is called a tab well.
With the Layout created we call `FAssetEditorToolkit::InitAssetEditor`.

You can find examples of how to create Styles in  `Engine/Source/Editor/EditorStyle/Private/SlateEditorStyle.cpp`.


[[2020-09-10_19:55:50]] [Modules](./Modules.md)  
[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  
[[2020-08-31_10:01:57]] [Garbage collection](./Garbage%20collection.md)  

[[2020-03-11_19:00:31]] [Assets](./Assets.md)  
[[2020-08-17_09:45:29]] [Loading assets](./Loading%20assets.md)  
[[2020-03-10_21:23:32]] [Naming convention](./Naming%20convention.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  

[Custom Asset Editors Code Exploration @ learn.unrealengine.com](https://learn.unrealengine.com/course/2436528/module/5372752?moduletoken=UHxxnDLPW8ROFOnyLDf7jkpDsWH-6EgInZkaEVy-utqnxQVniUN~z2b6Dq5f9wUr&LPId=0)
[TextAsset @ github.com](https://github.com/ue4plugins/TextAsset)  
[C++ Extending the Editor | Live Training | Unreal Engine by Unreal Engine @ youtube.com](https://youtu.be/zg_VstBxDi8?t=1731)
[Writing a Custom Asset Editor for Unreal Engine 4](http://cairansteverink.nl/cairansteverink/blog/writing-a-custom-asset-editor-for-unreal-engine-4-part-1/)  
[Asset Editor -Development of asset editor in Unreal Engine](https://easycomplex-tech.com/blog/Unreal-AssetEditor/)  
