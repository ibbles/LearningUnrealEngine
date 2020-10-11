2020-08-31_10:01:57

# Garbage collection

Unreal Engine uses reference counting to implement garbage collection.

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
        // Safe to use TextAssets elements here, but check for validity first.
    })
}
```

[[2020-10-03_10:38:42]] [Creating new asset types](./Creating%20new asset%20types.md)  

Can find the existing references:
```c++
TArray<UObject> ReferredToObjects; //req outer, ignore archetype, recursive, ignore transient
FReferenceFinder ObjectReferenceCollector = FReferenceFinder(
    ReferredToObjects, Obj, false, true, true, false);
ObjectReferenceCollector.FindReferences(Obj);
```

