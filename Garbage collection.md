2020-08-31_10:01:57

# Garbage collection

Garbage collection is used to avoid having to manually call `delete` on dynamically allocated objects that are no longer referenced.
Types marked with `UCLASS`, called UObjects, or `USTRUCT` (I think), called UStructs, are garbage collected.

(This section on reference counting is likely incorrect.)
Unreal Engine uses reference counting to implement garbage collection.
Any pointer held by a UClass or UStruct (I think) type in a `UPROPERTY` member variable participate in the reference counting of the pointed-to object.
The pointed-to object is marked for deletion when the last `UPROPERTY` pointer to it is cleared or redirected, i.e., the reference count reaches zero.
Objects marked for deletion are deleted on the next garbage collection cycle.
You should not manually delete `UCLASS` and `USTRUCT` (I think) objects.
(End of possibly incorrect section on reference counting.)

The engine builds a *reference graph* to keep track of which objects are orphaned and which are still in use.
The graph originate at a set of UObjects that form the *root set*.
At regular intervals the engine will perform *garbage collection* by traverse recursively from all objects in the root set through all UObjects it finds.
Any object encountered during this process is considered to be in use.
Any object not encountered is considered to be unreferenced and will be removed.
While traversing, the search will consider any UProperty pointer to a UObject, as well as any such pointer stored in an Unreal Engine container such as a `TArray` as a reference and recurse through those pointers.
A raw C++ `UObject*` will not be included.

[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2021-06-22_08:34:55]] [UProperties](./UProperties.md)  

An instance can also be explicitly *flagged for destruction*.
That will set all UProperty pointers and TWeakObjectPtrs to that instance to `nullptr`.
Actors are destroyed by calling their `Destroy` member function.
Components are destroyed by calling their `DestroyComponent`, or by destroying the Actor that owns the Component.
Other objects are destroyed by calling `MarkPendingKill` or `ConditionalBeginDestroy`.
I don't know what the difference between `MarkPendingKill` and `ConditionalBeginDestroy` is.
[Memory management, smart pointers and debugging @ programmersought.com](https://www.programmersought.com/article/10374623602/) write that `ConditionalBeginDestroy` should be used on objects created with `NewObject`.

From [UObjectBaseUtility::MarkPendingKill @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/API/Runtime/CoreUObject/UObject/UObjectBaseUtility/MarkPendingKill/):

> Marks this object as RF_PendingKill.

From [UObject::ConditionalBeginDestroy @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/API/Runtime/CoreUObject/UObject/UObject/ConditionalBeginDestroy/):

> Called before destroying the object. This is called immediately upon deciding to destroy the object, to allow the object to begin an asynchronous cleanup process.

From [Destruction of UObjects @ answers.unrealengine.com](https://answers.unrealengine.com/questions/12111/destruction-of-uobjects.html):

> UObjects are garbage collected after the last reference is set to null.
>
> An object can be marked as "Pending Kill" (with MarkPendingKill()) to cause the garbage collector to null any accessible references on the next garbage collection and make FindObject() etc ignore the object.
> 
> Actor-derived classes can be explicitly destroyed with DestroyActor(), which essentially works by calling various OnDestroyed() callbacks, removing the actor from the level and calling MarkPendingKill() to clean up any references.



There are a collection of garbage collection *settings* in the Project Settings.

Something related to garbage collection is done with `MyUObject->ConditionalBeginDestroy`.
(What is this? What does it do? How does it compare to `MarkPendingKill?`)

Can do `GetWorld()->ForceGarbageCollection(false)`.
Or `true`, don't know what the parameter means.

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




[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2021-06-22_08:34:55]] [UProperties](./UProperties.md)  


[Objects @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/Objects/)  
[Garbage Collection @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/Objects/Optimizations/#garbagecollection)  
