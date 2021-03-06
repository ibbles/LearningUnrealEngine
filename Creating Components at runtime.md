2020-08-14_09:32:03

# Creating Components at runtime

## Blueprint

Create new Components in an Actor Blueprint with the Add COMPONENT_NAME Component function.
For example: Add Static Mesh Component.

This doesn't seem to work when not within the Actor Blueprint itself.
One cannot create Components in an Actor that one has a reference to.


## C++

Cannot use `CreateDefaultSubobject` outside of a constructor.
Instead use `NewObject` and add/register manually.

```c++
void AMyActor::CreateMyComponent()
{
    UMyComponent* MyComponent = NewObject<UMyComponent>(
        this, TEXT("MyComponent"));
    MyComponent->SetRelativeLocation(
        FVector(0, 0, 0.0));
    MyComponent->SetFlags(RF_NoFlags);
    MyComponent->RegisterComponent();
    MyComponent->AttachToComponent(
        RootComponent,
        FAttachmentTransformRules::KeepRelativeTransform,
        NAME_None)
    AddInstanceComponent(MyComponent);
}
```

Worrying comment in the Unreal Slackers Discord:

> For anyone interested in a solution to what I was working on yesterday: it turns out using `NewObject<>` blindly is insufficient for creating sub-objects in editor assets. To set the proper flags for UE4 to treat new instances as if they were created by the editor, use `SetFlags(GetMaskedFlags(RF_PropagateToSubObjects))`. For example:

```c++
virtual void PostEditChangeChainProperty(
    FPropertyChangedChainEvent& PropertyChangedEvent) override
{
    UBBSIntAttributeNode* IntNode = NewObject<UBBSIntAttributeNode>(this);
    IntNode->SetFlags(GetMaskedFlags(RF_PropagateToSubObjects));
    IntNode->intValue = value;
    Attributes.Add(AttributeClass, IntNode);
}
```
I don't understand anything of the above.


If you want to create Components in C++ then the Root Component must also be created in C++, not the Blueprint.
Otherwise there's no Root Component to add the newly created Component to.
Blueprint initialization happens after the C++ object has been fully constructed.
Delayed Component creation should be in `BeginPlay`.
(
I don't think the above is quite true. Seems odd to me. There are many places in which Components can be created. I guess...
)


The relationship between `AttachTo`(`Compoent`?) and `SetupAttachment` is unclear to me.

Another suggestion for how to create a new Component instance:
```c++
void AMyActor::MakeSomeComponent() {
  if (!my_comp) {
    my_comp = NewObject<USplineComponent>(this, FName{ "some spline" });
    my_comp->RegisterComponent();
    auto rootcomp = GetRootComponent();
    my_comp->SetWorldLocationAndRotation(rootcomp->GetComponentLocation(), FRotator::ZeroRotator);
    my_comp->AttachTo(rootcomp, NAME_None, EAttachLocation::Type::KeepWorldPosition);
  }
}
```

```c++
void ASomeActor::MakeSomeComponent() {
  if (!my_comp) {
    my_comp = NewObject<USplineComponent>(this, FName{ "some spline" });
    my_comp->SetupAttachment(RootComponent);
    my_comp->RegisterComponent();
  }
}
```

```c++
void ASomeActor::MakeSomeComponent() {
  if (!my_comp) {
    my_comp = NewObject<USplineComponent>(this, FName{ "some spline" });
    my_comp->RegisterComponent();
    my_comp->AttachToComponent(RootComponent, NAME_None, EAttachLocation::SnapTotarget);
  }
}
```

> `EAttachLocation::SnapToTarget` does what the two last lines do, FWIW
> I think SetupAttachment works okay so long as you call it prior to RegisterComponent() btw


Optional Components are created with something along the lines of
```c++
AParent::AParent(const FObjectInitializer& OI)
    Super(OI)
{
    MyCompA = OI.CreateOptionalDefaultSubobject<UMyComponentA>(
        this, UMyComponentA::MyComponentAName);
    MyCompB = OI.CreateOptionalDefaultSubobject<UMyComponentB>(
        this, UMyComponentB::MyComponentAName);
}

AChild::AChild(const FObjectInitializer& OI)
    : Super(
        OI
        .DoNotCreateDefaultSubobject(UMyComponentA::MyComponentAName)
        .DoNotCreateDefaultSubobject(UMyComponentB::MyComponentBName))
    {}
```