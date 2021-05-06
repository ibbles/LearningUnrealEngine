2021-04-29_19:49:58

# Blueprints and C++

I expected that this entire text is editor only.
I don't think one can create new Blueprints at game time.

A Blueprint is represented in C++ with an instance of the `UBlueprint` class.

In addition to its own class, a Blueprint also has a Generated Blueprint class.
Both of these are `UClass` instances.
We can get the Blueprint type and the Blueprint Generated type as follows:
```cpp
IKismetCompilerInterface& KismetCompilerModule = 
    FModuleManager::LoadModuleChecked<IKismetCompilerInterface>("KismetCompiler");

UClass* BlueprintClass = nullptr;
UClass* BlueprintGeneratedClass = nullptr;

KismetCompilerModule.GetBlueprintTypesForClass(
    // The class to get the Blueprint classes for.
    YourClassType::StaticClass(),
    // Pointer that will be set to the class' Blueprint class.
    BlueprintClass, 
    // Pointer that will be set to the class' Blueprint generated class.
    BlueprintGeneratedClass);
```

According to [the documentation](https://docs.unrealengine.com/en-US/API/Runtime/CoreUObject/UObject/UClass/index.html) `UClass` is:

> An object class.

That helped me absolutely nothing.
The `UMyClass::StaticClass()` static member function returns the `UClass` for `UMyClass`.
It contains reflection data, I believe.


The documentation for `UBlueprintGeneratedClass` is the empty string.


## Create a new Blueprint class from scratch

A new Blueprint class is created with`FKismetEditorUtilities::CreateBlueprint`:
```cpp
#include "AssetToolsModule.h"
#include "PackageTools.h"
#include "ObjectTools.h"
#include "KismetCompilerModule.h"
#include "Kismet2/KismetEditorUtilities.h"
#include "AssetRegistryModule.h"

void CreateBlueprint(UClass* ParentClass)
{
	// Get the Asset Tools module, which is used to work with assets.
	// A Blueprint class is an asset.
	FAssetToolsModule& AssetToolsModule =
        FModuleManager::GetModuleChecked<FAssetToolsModule>("AssetTools");

	// The name of the Blueprint we are about to create.
	FName Name = []() -> FName {
		// The name we would like to give the new Blueprint class.
		FString Name = "BP_TestBlueprint";
		
		// Sanitize the name so that it doesn't contain any illegal characters for use in package names.
		Name = UPackageTools::SanitizePackageName(Name);
		
		// Sanitize it again, this time removing characters illegal for use in object names.
		Name = ObjectTools::SanitizeObjectName(Name);
		
		// Create an FName from the string.
		return *Name;
	}();

	// Decide where to place the asset on disk / in the Content Browser.
	FString PackagePath = "/Game/Test/" + Name;
	
	// Create a Package to put the Blueprint in.
	UPackage* OuterForAsset = CreatePackage(nullptr, *PackagePath);

	// Declare the types for the Blueprint and its generated class.
	// Don't know what this is.
	UClass* BlueprintClass = nullptr;
	UClass* BlueprintGeneratedClass = nullptr;

	// Load the compiler module.
	IKismetCompilerInterface& KismetCompilerModule =
        FModuleManager::LoadModuleChecked<IKismetCompilerInterface>("KismetCompiler");
	
	// Fill in BlueprintClass and BlueprintGeneratedClass.
	// I don't know what YourClassType is/should be. The parent class of our new Blueprint class?
	KismetCompilerModule.GetBlueprintTypesForClass(
		ParentClass, // The class to get the Blueprint classes for.
		BlueprintClass, // Pointer that will be set to the class' Blueprint class.
		BlueprintGeneratedClass); // Pointer that will be set to the class' Blueprint generated class.
	
	// Create the new Blueprint class.
	UBlueprint* NewBlueprint = FKismetEditorUtilities::CreateBlueprint(
		// The class that the new Blueprint will inherit from.
		ParentClass,
		// The Package that the Blueprint will be created in.
		OuterForAsset,
		// The name to give to the new Blueprint class.
		Name,
		// The type of Blueprint class to create.
        // Some examples are Normal, Const, MacroLibrary, Interface,
        // LevelScript and FunctionLibrary.
		BPTYPE_Normal,
		// The class of the new Blueprint class.
		// Don't understand why we need to supply this.
		// I thought this is what we are creating.
		BlueprintClass,
		// The generated class of the new Blueprint class.
		// Don't understand why we need to supply this.
		// I thought this is what we are creating.
		BlueprintGeneratedClass,
		// A name used for analytics.
		FName("GeneratingBlueprintTest"));

    // Tell the engine about the new Blueprint.
	FAssetRegistryModule::AssetCreated(NewBlueprint);
    
    // Open the Blueprint in the Blueprint Editor.
    // This has been deprecated in Unreal Engine 4.25.
    // Instead use the matching function on AssetEditorSubsystem.
	FAssetEditorManager::Get().OpenEditorForAsset(NewBlueprint);

    // Save the Package, and thus the Blueprint, to disk.
	OuterForAsset->SetDirtyFlag(true);
	TArray<UPackage*> PackagesToSave;
	PackagesToSave.Add(OuterForAsset);
	FEditorFileUtils::PromptForCheckoutAndSave(PackagesToSave, false, false);
}
```

I don't yet know how to add Component, variables, and functions to the Blueprint from C++.


## Create a new Blueprint class from a template Actor

Another way is to create and populate an Actor, called the template Actor, with the Components we want to initialize the Blueprint with and then let the Engine create the Blueprint class for us.

```cpp
UBlueprint* NewBlueprint = FKismetEditorUtilities::CreateBlueprintFromActor(
    // Package created just as in the "Create a new Blueprint class from scratch"
    // section above.
    Package->GetName(),
    // The AActor* that we want to duplicate into a Blueprint class.
    Template,
    // bReplaceActor. Replace Template in the scene with an instance of the new Blueprint class.
    false,
    // Copy the Mobility of each Component to the new Blueprint class.
    true);
```


A template Actor with an example Component can be created as follows:
```cpp
// Get the EmptyActor factory, which is used to create empty Actor instances.
UActorFactory* Factory =
    GEditor->FindActorFactoryByClass(UActorFactoryEmptyActor::StaticClass());

// Create configuration data for the to-be-created Actor.
// And empty Actor doesn't really have any configuratoin.
FAssetData EmptyActorAssetData = FAssetData(Factory->GetDefaultActorClass(FAssetData()));

// Use the configuration data to create an Asset.
// I have no idea what this is.
UObject* EmptyActorAsset = EmptyActorAssetData.GetAsset();

// Use the Asset to create 
AActor* Template =
    FActorFactoryAssetProxy::AddActorForAsset(EmptyActorAsset, false);
check(Template != nullptr); /// \todo Test and return false instead of check?

// Not sure about this part.
// RF_Transactional means that it's included in undo history.
// But this is a temporary Actor, we don't need undo for it.
// Was RF_Transient meant instead?
Template->SetFlags(RF_Transactional);

// Not sure if this does anything. This Actor will never be seen
// in the World Outliner. Will the label be used for something
// in the new Blueprint class?
Template->SetActorLabel(FString("MyTemplateActor"));

// The following part is repeated for each Component to add.

// Create a Component in the template Actor.
UMyComponent* Component = NewObject<UMyComponent>(Template);

// Give the new component a name.
// The name has to be unique, which can get complicated.
// See Rename.md.
Component->Rename(TEXT("MyComponentName"), nullptr, REN_DontCreateRedirectors);

// Configure the Component.
// Here we set the RF_Transactional flag, so that this component is
// included in the undo history.
// You can do whatevere other configure you may need.
// For example, setting the color of a light source, assing a
// StaticMesh to a StaticMeshComponent, or add spline points to
// a SplineComponent.
Component->SetFlags(RF_Transactional);

// Let the Actor know that it has been given a new Component.
Template->AddInstanceComponent(Component);

// Register the Component. No idea what this does or why we need
// to do it explicitly. But we need to.
Component->RegisterComponent();

// Not sure why/if this is need.
Component->PostEditChange()
```


[[2020-06-16_09:19:36]] [Rename](./Rename.md)  