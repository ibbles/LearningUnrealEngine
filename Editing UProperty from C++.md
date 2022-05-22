2021-11-03_14:14:15

# Editing UProperty from C++

For game logic there's not much to it, simply write to the UProperty member variable.

For editor code things are a bit more complicated in order to support the Details Panel, Blueprint Editor, templates and instances, undo/redo, change events, and Component Visualizers.

We can do the edit from a Details Panel input widget callback, a post edit event, a Component Visualizer, 

Engine code seems to do things differently from place to place and it is very unclear to me what the rules really are.
On purpose of this text is to try and figure it out.

In these examples `UMyObject` represents some project specific `UObject` deriving class and `SomeProperty` is an UProperty in that object.

Functions we can call:
- `GEditor->BeginTransaction()`
- `UObject::PreEditChange(FProperty*)`.
- `UObject::Modify()`.
- Edit the object here.
- `UObject::HasAnyFlags(RF_ArchetypeObject)`.
- `UObject::GetArchetypeInstances`.
- `FPropertyChangedEvent::FPropertyChangedEvent(FProperty*, EPropertyChangeType)`.
- `UObject::PostEditChangeProperty(FPropertyChangedEvent)`.
- `GEditor->EndTransaction()`.

We can also go through an `IPropertyHandle`.
- `FScopedTransaction`
- `IPropertyHandle::SetValue()`.

I'm not sure how much of all of this one has to do when using `IPropertyHandle::SetValue`.

## Undo/redo, Transactions, Modify

To support undo/redo of a modification we must record a transaction and mark any modified objects we wish to reset during the undo.

```cpp
void IncrementSomeProperty(UMyObject& MyObject)
{
    GEditor->BeginTransaction(LOCTEXT("IncrementSomeProperty", "Increment Some Property"));
    MyObject.Modify();
    ++MyObject.SomeProperty;
    GEditor->EndTransaction();
}
```

`UObject::PreEditChange(FProperty*)` will call `Modify` for us, so it if often not necessary to call it explicitly.

```cpp
void IncrementSomeProperty(UMyObject& MyObject)
{
    GEditor->BeginTransaction(LOCTEXT("IncrementSomeProperty", "Increment Some Property"));
    FProperty* Property = FindFProperty<FProperty>(
        UMyObject::StaticClass(), GET_MEMBER_NAME_CHECKED(UMyObject, SomeProperty));
    MyObject.PreEditChange(Property);
    ++MyObject.SomeProperty();
    FPropertyChangedEvent PropertyChangeEvent(Property, EPropertyChangeType::ValueSet);
    MyObject.PostEditChangeProperty(PropertyChangeEvent);
    GEditor->EndTransaction();
}
```

`UObject::PostEditChangeProperty` broadcasts `FCoreUObjectDelegates::OnObjectPropertyChanged`.
Also does something about transaction buffers for interactive changes.

There is a `FScopedTransaction` that helps with the begin/end transaction calls.
```cpp
void IncrementSomeProperty(UMyObject& MyObject)
{
    FScopedTransaction Transaction(LOCTEXT("IncrementSomeProperty", "Increment Some Property"));
    FProperty* Property = UMyObject::StaticClass()->FindPropertyByName(
        GET_MEMBER_NAME_CHECKED(UMyObject, SomeProperty));
    MyObject.PreEditChange(Property);
    ++MyObject.SomeProperty;
    FPropertyChagnedEvent PropertyChangedEvent(Property, EPropertyChangeType::ValueSet);
    MyObject.PostEditChangeProperty(PropertyChangeEvent);
}
```


## Blueprints, Templates, and Instances

If we edit an object that is a Blueprint Template then we should also update any instances, including subclasses, of the Blueprint that hasn't overridden the value.
The engine has a helper function that does this for Scene Components, `FComponentEditorUtils::PropagateDefaultValueChange`.
I don't know why that doesn't work on `UObject` instead.
This crashes with
```
Assertion failed: GetOwner<UClass>() [File:Runtime/CoreUObject/Public/UObject/UnrealType.h] [Line: 376] 
```

For everything else:
We can identify Templates with `MyObject.IsTemplate()`.
We list the instances to update with `UObject::GetArchetypeInstances`.

```cpp
void IncrementSomeProperty(UMyObject& MyObject)
{
    const float OldSomeProperty = MyObject.SomeProperty;

    // Same as before.
    FScropedTransaction Transaction(LOCTEXT("IncrementSomeProperty", "Increment Some Property"));
    FProperty* Property = UMyObject::StaticClass()->FindPropertyByName(
        GET_MEMBER_NAME_CHECKED(UMyObject, SomeProperty));
    MyObject.PreEditChange(Property);
    ++MyObject.SomeProperty;
    FPropertyChangedEvent PropertyChangedEvent(Property, EPropertyChangeType::ValueSet);
    MyObject.PostEditChangeProperty(ChangedEvent);
    
    // Change instances with the same value.
    // @Note I worry that this wont correctly handle the case where the instance is
    // actually an instance of a Blueprint deriving from the Blueprint that MyObject
    // is the template for. Consinder BP_A[9] > BP_B[8] > InstOfB[9] where the numbers
    // in [] are the current value of SomeProperty and InstOfB is an instance of the
    // Blueprint BP_B, and BP_B inherits from BP_A. If we edit SomeProperty on BP_A
    // then I believe InstOfB will be updated as well even though the user explicitly
    // set a value on InstOfB, overriding the 8 set in the Blueprint BP_B.
    if (MyObject.IsTemplate())
    {
        TArray<UObject*> Instances;
        MyObject.GetArchetypeInstances(Instances);
        for (UObject* Object : Instances)
        {
            UMyObject* Instance = Cast<MyObject>(Object);
            if (Instance == nullptr)
            {
                continue;
            }
            if (Instance->SomeProperty == OldSomeProperty)
            {
                Instance->PreEditChange(Property);
                Instance->SomeProperty = MyObject.SomeProperty;
                Instance->PostEditChangeProperty(ChangedEvent);
            }
        }
    }
}
```

## Engine code examples

These are simplified/summarized versions of how engine code handles these matters.

### `FComponentMaterialCategory`

This is a Details Panel customization.
It uses `(Begin|End)Transaction`, `UObject::PreEditChange`, `UObject::PostEditChangeProperty`, `UObject::GetArchetypeInstances`.


(
I think there are typos in the below. Investigate.
)
```cpp
GEditor->BeginTransaction();
FProperty* MaterialProperty = FindFProperty<FProperty>(
    UMeshComponent::StaticClass(), "OverrideMaterials");
EditedObject->PreEditChange(MaterialProperty);
→    Modify();
FPropertyChangedEvent PropertyChangedEvent(MaterialProperty);
EditedObject->SetMaterial(InElementIndex, InNewMaterial);
→    OverrideMaterials[ElementIndex] = Material;
→    MarkRenderStateDirty();

TArrayTArray<UObject*> ComponentArchetypeInstances;
if(EditedObject->HasAnyFlags(RF_ArchetypeObject))
{
    EditedObject->GetArchetypeInstances(ComponentArchetypeInstances);
}
else if (/* EditedObject has outer. */)
{
    /*
     * Find all archetype instances of the outer and then the (if any) inner of each instance
     * that has the same class and name as EditedObject. Add those to ComponentArchetypeInstances.
     */
}
for(auto ComponentArchetypeInstance : ComponentArchetypeInstances)
{
    ComponentArchetypeInstance->PreEditChange(MaterialProperty);
    ComponentArchetypeInstace->SetMaterial(...);
    ComponentArchetypeInstance->PostEditChangeProperty(PropertyChangedEvent);
}

FPropertyChangedEvent PropertyChangdeEvent(
    ObjectData.PropertyThatChanged, EPropertyChangeType::ValueSet);
EditedObject->PostEditChangeProperty(PropertyChangeEvent);
// Called via NotifyHook->NotifyPostChange(PropertyChangeEvent, ObjectData.PropertyThatChanged);
// where NotifyHook is UUnrealEdEngine.
GLevelEditorModeTools().ActorPropChangeNotify();

GEditor->EndTransaction();
GUnrealEd->RedrawLevelEditingViewports();
```


## `FLightComponentDetails::SetComponentIntensity`

This is a Details Panel customization.

Simplified/reduced version of `FLightComponentDetails::SetComponentIntensity` demonstrating what it does to handle the update.
```cpp
void FLightComponentDetails::SetComponentIntensity(ULightComponent* Component, float InIntensity)
{
    FProperty* Property = FindFProperty<FProperty>(ULightComponent::StaticClass(), "Intensity");
    // It doesn't have a call to Component->PreEditChange(Property) here. Why not?
    FPropertyChangedEvent PropertyChangedEvent(Property);
    const float  PreviousIntensity = Component->Intensity;
    Component->Intensity = InIntensity;
    Component->PostEditChangeProperty(PropertyChangedEvent);
    
    for (ULightComponent* Instance : Component->GetArchetypeInstances())
    {
        if (InstanceComponent->Intensity == PreviousIntensity)
        {
            // It doesn't have a call to Component->PreEditChange(Property) here. Why not?
            Instance->Intensity = Component->Intensity;
            Instance->PostEditChangeProperty(PropertyChangedEvent);
        }
    }
}
```




## `FMatrixStructCustomization::FlushValues`

This is a Details Panel customization.
This uses a Property Handle instead of an `UObject*` to access the data to modify.
`FlushValues` is called from `OnValueCommitted` and such.

```cpp
bool  FMatrixStructCustomization::FlushValues(IPropertyHandle* PropertyHandle)
{
    // Get pointers to the modified FMatrix elements.
    TArray<void*> RawData = PropertyHandle->AccessRawData();
    // Get pointers to the UObjects owning the FMatrix elements.
	TArray<UObject*> OuterObjects = PropertyHandle->GetOuterObjects();

    for (Int I = 0; i < RawData.Num(); ++I)
    {
        // Get a pointer to this particular FMatrix.
        FMatrix* MatrixValue = reinterpret_cast<FMatrix*>(RawData[I]);
        
        // Store the current/old value so we can compare it with Instances later.
        const FMatrix PreviousValue = *MatrixValue;
        
        // CachedRotation is set by edits from the widget.
        const FMatrix NewValue = FRotationMatrix(CachedRotation);
        
        // Starta undo/redo transaction.
        GEditor->BeginTransaction(LOCTEXT("SetRotation", "SetRotation"));
        
        // Not sure what this does yet.
        PropertyHandle->NotifyPreChange();
        
        // Do the actual write.
        *MatrixValue = NewValue;
        
        // Handle the Blueprint case.
        if (OuterObjects[I]->IsTemplate())
        {
            // Loop over all the instances.
            for (UObject* Instance : OuterObjects[I]->GetArchetypeInstances())
            {
                // Get a pointer to this particular Instance's FMatrix.
                FMatrix* CurrentValue =
                    reinterpret_cast<FMatrix*>(
                        PropertyHandle->GetValueBaseAddress(
                            reinterpret_cast<uint8*>(ArchetypeInstance)));
                
                // Check if the Instance have the same value as the modified object had.
                if (CurrentValue->Equals(PreviousValue))
                {
                    // The Instance have the same value as the Template had, so update it as well.
                    *CurrentValue = NewValue;
                }
            }
        }
    }
    
    // We have now updated both the edited object and all its instances.
    
    
    PropertyHandle->NotifyPostChange(EPropertyChangeType::ValueSet);
    GEditor->EndTransaction();
    
    TSharedPtr<IPropertyUtilities> PropertyUtilities =
        IPropertyTypeCustomizationUtils::GetPropertyUtilities();
    FPropertyChangedEvent ChangeEvent(PropertyHandle->GetProperty(), EPropertyChangeType::ValueSet);
    PropertyUtilities->NotifyFinishedChangingProperties(ChangeEvent);
}
```

`PropertyHandle->NotifyPostChange` calls `FPropertyHandleBase::NotifyPostChange`.
`FPropertyHandleBase::NotifyPostChange` calls `FPropertyNode::NotifyPostChange(FPropertyChangedEvent)`.
`FPropertyNode::NotifyPostChange` calls `UObject::PostEditChangeProperty` and/or `UObject::PostEditChangeChainProperty`.
In fact, it does a whole bunch of stuff.
I don't think we're supposed to duplicate this functionality when we don't have a `IPropertyHandle`.





### `FParticleSystemComponentDetails::OnResetEmitter()`

This one doesn't follow the typical pattern.
For a Template it explicitly looks for the Component that has an `FActorEditorUtils::IsAPreviewOrInactiveActor` owner.


### `FComponentVisualizer::NotifyPropertiesModified`

This is a helper function of some kind used by Component Visualizers when editing the visualized Components.

```cpp
void  FComponentVisualizer::NotifyPropertiesModified(
    UActorComponent* Component, const  FProperty* Property)
{
    FPropertyChangedEvent PropertyChangedEvent(Property);
    Component->PostEditChangeProperty(PropertyChangedEvent);
    AActor* Owner = Component->GetOwner();
    if (!FActorEditorUtils::IsAPreviewOrInactiveActor(Owner))
    {
        return;
    }
    
    TArray<UActorComponent*> ComponentsToUpdate;
    UActorComponent* Archetype = Cast<UActorComponent>(Component->GetArchetype());
    TArray<UActorComponent*> Instances =
        Archetype->GetArchetypeInstances(ArchetypeInstances);
    for (UActorComponent* Instance : ArchetypeInstances)
    {
        uint8* ArchetypePtr = Property->ContainerPtrToValuePtr<uint8>(Archetype);
        uint8* InstancePtr = Property->ContainerPtrToValuePtr<uint8>(Instance);
        if (Property->Identical(ArchetypePtr, InstancePtr))
        {
            ComponentsToUpdate.Add(Instance);
        }
    }
    
    Archetype->SetFlags(RF_Transactional);
    Archetype->Modify();
    
    uint8* ArchetypePtr = Property->ContainerPtrToValuePtr<uint8>(Archetype);
    uint8* PreviewPtr = Property->ContainerPtrToValuePtr<uint8>(Component);
    Property->CopyCompleteValue(ArchetypePtr, PreviewPtr);
    FPropertyChangedEvent PropertyChangedEvent(Property);
    Archetype->PostEditChangeProperty(PropertyChangedEvent);
    
    for (UActorComponent* Instance : ComponentsToUpdate)
    {
        Instance->SetFlags(RF_Transactional);
        Instance->Modify();
        uint8* InstancePtr = Property->ContainerPtrToValuePtr<uint8>(Instance.ArchetypeInstance);
        uint8* PreviewPtr = Property->ContainerPtrToValuePtr<uint8>(Component);
        Property->CopyCompleteValue(InstancePtr, PreviewPtr);
        FPropertyChangedEvent PropertyChangedEvent(Property);
        Instance->PostEditChangeProperty(PropertyChangedEvent);
    }
    
    Owner->PostEditMove(false);
}
```

### `PropagateDefaultValueChange`

```cpp
void PropagateDefaultValueChange(
    USceneComponent* Template, FProperty* Property, T& OldValue, T& NewValue)
{

}
```













