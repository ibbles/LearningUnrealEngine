2020-08-31_10:01:57

# Garbage collection

Uses reference counting.

Something related to garbage collection is done with `MyUObject->ConditionalBeginDestroy`.

Can do `GetWorld()->ForceGarbageCollection(false)`.

`IsReferenced`

`IncrementalPurgeGarbage`

`IsUnreachable`



Can find the existing references:
```c++
TArray<UObject> ReferredToObjects; //req outer, ignore archetype, recursive, ignore transient
FReferenceFinder ObjectReferenceCollector = FReferenceFinder(
    ReferredToObjects, Obj, false, true, true, false);
ObjectReferenceCollector.FindReferences(Obj);
```