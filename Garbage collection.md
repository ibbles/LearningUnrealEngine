2020-08-31_10:01:57

# Garbage collection

Garbage collection is used to avoid having to manually call `delete` on dynamically allocated objects that are no longer referenced.
Types marked with `UCLASS` or `USTRUCT` (I think) are garbage collected.
Unreal Engine uses reference counting to implement garbage collection.
Any pointer held by a `UCLASS` or `USTRUCT` (I think) type in a `UPROPERTY` member variable participate in the reference counting of the pointed-to object.
The pointed-to object is marked for deletion when the last `UPROPERTY` pointer to it is cleared or redirected.
Objects marked for deletion are deleted on the next garbage collection cycle.
You should not manually delete `UCLASS` and `USTRUCT` (I think) objects.

Something related to garbage collection is done with `MyUObject->ConditionalBeginDestroy`.

Can do `GetWorld()->ForceGarbageCollection(false)`.

`IsReferenced`

`IncrementalPurgeGarbage`

`IsUnreachable`

Sometimes we want to keep references to objects without participating in the reference counting.
For example when generating a right-click menu for some object(s).
In that case store the pointers in a `WeakObjectPtr`.
For example:
```c++
void FMyAssetAction::GetActions(
        const TArray<UObject*>& InObjects,
        FMenuBuilder& MenuBuilder)
{
    TArray<TWeakObjectPtr<UTextAsset>> TextAssets =
        GetTypedWeakObjectPtrs<UTextAsset>(InObjects);
    MenuBuilder.AddMenuEntry([=] {
        // Safe to use TextAssets elements here, but check IsValid first.
    })
}
```

[[2020-10-03_10:38:42]] [Creating new asset types](./Creating%20new%20asset%20types.md)  

Can find the existing references:
```c++
TArray<UObject> ReferredToObjects; //req outer, ignore archetype, recursive, ignore transient
FReferenceFinder ObjectReferenceCollector = FReferenceFinder(
    ReferredToObjects, Obj, false, true, true, false);
ObjectReferenceCollector.FindReferences(Obj);
```

## Owners that aren't UObject

The normal way to hold an owning reference is to have an `UObject` owner with a `UPROPERTY` member that is a pointer to an `UObject` instance.
It is possible to hold an owning reference in something not an `UObject` be inheriting from `FGCObject` and implementing `AddReferencedObjects`.
