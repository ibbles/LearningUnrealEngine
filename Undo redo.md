2020-09-30_13:19:47

# Undo redo

Undo-redo regions are created from C++ by creating an `FScopedTransaction` on the stack.
The name of the transaction is displayed in the undo history and in a popup when being undone.
All marked modifications done while the `FScopedTransaction` is active become a single undo step.
An operation is considered marked if it modifies a `UPROPERTY` and `Modify` has been called on the
modified object before the modification is done.
There may also be something about whether or not the `UPROPERTY` is replicated. Not sure.
`Modify` is a member of `UObject`.
Example:
```c++
UCLASS()
class UActorMover : public UObject
{
public:
    GENERATED_BODY();
    
    UPROPERTY()
    AActory* MyActor;
    
    UPROPERTY()
    int32 NumMoves;
    
    void MoveActor();
}

void UMyClass::MoveActor()
{
    // Start a new undo transaction. Any marked changes made until
    // this object goes out of scope is considered a single atomic
    // operation in the undo history.
    FScopedTransaction Transaction(
        LOCTEXT("MoveActor", "Move actor."));
    
    // This member function will make two changes, one to itself and
    // one on the Actor it has a pointer to.
    
    // Mark this object as about to be modified.
    this->Modify();
    
    // Make the modification. NumMoves is a `UPROPERTY` on an objects on
    // which Modify has been called so it will be included in the 
    ++NumMoves;
    
    // Next we do the move. First mark the Actor for modification and then
    // do the actual modification. AActor is responsible for doing any
    // propagation of the Modify to sub-objects that may be necessary in
    // case the modifying member function, SetActorLocation in this case,
    // modifies a sub-object.
    MyActor->Modify();
    MyActor->SetActorLocation();
    
}
```

```
FScopedTransaction transaction(); // will open up a slot in for data in GEditor
Modify(); // On what should this be called? The FScopedTransaction? Or is `Modify` a stand-in name for any modification on any object?
// Do you modifications.

//~FScopedTransaction() will finish the transaction, called when `transaction` goes out of scope.
```