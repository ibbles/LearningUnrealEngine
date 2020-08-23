2020-08-14_09:32:03

# Creating Components at runtime

Cannot use `CreateDefaultSubobject` outside of a constructor.
Instead use `NewObject` and add/register manually.

```c++
UChunkBlocksComponent* ChunkBlocksComponent = NewObject<UChunkBlocksComponent>(
    this, *FString::Printf(TEXT("Chunk Z: %d"), ChunkID.Location.Z)); ChunkBlocksComponent->SetRelativeLocation(
    FVector(0, 0, ChunkID.Location.ToEngineLocation().Z)); ChunkBlocksComponent->SetFlags(RF_NoFlags);
ChunkBlocksComponent->RegisterComponent();
ChunkBlocksComponent->AttachToComponent(
    RootComponent, FAttachmentTransformRules::KeepRelativeTransform,
    NAME_None); 
AddInstanceComponent(ChunkBlocksComponent);
```

Worrying comment in the Unreal Slackers Discort:


> For anyone interested in a solution to what I was working on yesterday: it turns out using `NewObject<>` blindly is insufficient for creating sub-objects in editor assets. To set the proper flags for UE4 to treat new instances as if they were created by the editor, use `SetFlags(GetMaskedFlags(RF_PropagateToSubObjects))`. For example:

```c++
    virtual void PostEditChangeChainProperty(FPropertyChangedChainEvent& PropertyChangedEvent) override
        {
            UBBSIntAttributeNode* IntNode = NewObject<UBBSIntAttributeNode>(this);
            IntNode->SetFlags(GetMaskedFlags(RF_PropagateToSubObjects));
            IntNode->intValue = value;
            Attributes.Add(AttributeClass, IntNode);
        }
```