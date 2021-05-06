2020-12-31_17:03:18

# C++ inputs

The virtual member functions `APawn::SetPlayerInputComponent` and `APlayerController::SetupInputComponent` are called at the start of the game.
Called after the Pawn constructor and before Begin Play.
The Pawn version is passed an `UInputComponent`.
The Player Controller has a member named `InputComponent`
`UInputComponent` is used to bind input events to function callbacks.

The functions we bind should have these signatures:
- Action event: `void()`.
- Axis event: `void(float)`.

A member function is bound to a named input _action_ event with `BindAction`.
```cpp
FInputActionBinding UInputComponent::BindAction(
    FName ActionName, EInputEvent KeyEvent, UserClass* Object, FInputActionHandlerSignature Function);
```
A member function is bound to a named input _axis_ event with `BindAxis`.
```cpp
FInputAxisBinding UInputComponent::BindAction(
    FName AxisName, UserClass* Object, FInputActionHandlerSignature Function);
```

The names `ActionName` and `AxisName` must be input actions defined in Project Settings > Engine > Input > Bindings.
The `EInputEvent KeyEvent` is either `IE_Pressed` or `IE_Released`.
`Object` is a pointer to the object that should receive the callback,.
`Function` is a pointer to the member function that should be called.

An example `SetupPlayerInputComponent` implementation:
```cpp
UCLASS()
class AMyPawn : public APawn
{
public:
    GENERATED_BODY()

    virtual void SetupPlayerInputComponent(UInputComponent* Input);

    void OnInteractStart();
    void OnInteractEnd();
    void OnForward(float Value);
    void OnRight(float Value);
};

void AMyPawn::SetupPlayerInputComponent(UInputComponent* Input)
{
    Super::SetupPlayerInputComponent(Input);

    Input->BindAction("Interact", IE_Pressed, this, &AMyPawn::OnInteractStart);
    Input->BindAction("Interact", IE_Released, this, &AMyPawn::OnInteractEnd);

    Input->BindAxis("Forward", this, &AMyPawn::OnForward);
    Input->BindAxis("Right", this, &AMyPawn::OnRight);
}
```

[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  
[[2021-01-01_16:41:46]] [C++ Pawn](./C++%20Pawn.md)  
[[2021-01-03_17:40:41]] [C++ Character](./C++%20Character.md)  
[[2020-04-11_11:27:52]] [PlayerController](./PlayerController.md)  