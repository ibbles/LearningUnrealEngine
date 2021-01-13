2020-04-11_11:27:52

# Player Controller

A type of controller that reads input from the player, i.e., a game pad, keboard, mouse, joystic, or similar.
The Player Controller to use in a game is set in the *Game Mode*, either for the entire project or override per level.
A Player Controller have access to the *Pawn* it is controlling through the `GetPlayerPawn` function.
The Pawn is often of a known subclass whose type has been defined in the selected Game Mode.
The Player Controller Blueprint class often has a variable of the subclass type that is set in the Begin Play event.
`GetPlayerPawn` > `CastTo<Type>` > `SetVariable`.
The events that the Player Controller can receive are listed in Project Settings > Engine > Input.

(
The following paragraph uses Pawn motion as an example of a Player Controller input event.
That's often wrong, Pawn movement logic should be in the Pawn itself.
)

Each *Action Mapping* and *AxisMapping* corresponds to one event in the Player Controller.
Event start *execution nodes* are created by right-click and type the name of the event, i.e., `MoveForward`, or `TurnLeft`.
To find the world direction of the Pawn's forward vector we do `GetActorTransform`>`TransformDirection` passing in the unit X vector, since the X axis is forward in Unreal Engine.
Can use `FVector::RightVector`.
If the vector is a displacement then the new position is found by adding, with a `+` node, the transformed displacement to the `Location` property after breaking the `Transform`.
The result of the add, i.e., the new `Location`, is written back to a new `Transform` using a `Make Transform` node.
Just copy over the `Rotaion` and `Scale` from the old `Transform` to the new one.
The new `Transform` is applied to the `Actor` with `SetActorTransform`.

A Player Controller contains settings for who the *mouse* should behave.
Settings like Show Mouse Cursor, Enable Click Events, and Set Input Mode.
[[2021-01-13_14:37:12]] [Mouse cursor](./Mouse%20cursor.md).

The `PlayerController` can be found with:
- `AHUD::PlayerOwner`.
- FILL IN MORE WAYS HERE!

## Input events in C++

The C++ version of the Event nodes in the Event Graph is the `SetupInputComponent` member function.
In `SetupInputComponent` we bind actions to callbacks using `UInputComponent* AActor::InputComponent`.
```c++
void AMyPlayerController::SetupInputComponent()
{
    Super::SetupInputComponent();
    InputComponent->BindAction(
        "MyAction", IE_Pressed, this, &AMyPlayerComponent::MyAction);
}

void AMyPlayerController::MyAction()
{
    // Implement event behavior here.
}
```

See also [[2020-12-31_17:03:18]] [C++ inputs](./C++%20inputs.md) and [[2021-01-01_16:41:46]] [C++ Pawn](./C++%20Pawn.md). 


[[2020-04-11_11:18:18]] [Controller](./Controllermd)  
[[2020-04-11_11:28:47]] [AIController](./AIController.md)  
[[2020-04-11_11:26:21]] [Game mode](./Game%20mode.md)  
[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  
[[2020-12-31_17:03:18]] [C++ inputs](./C++%20inputs.md)  
[[2021-01-01_16:41:46]] [C++ Pawn](./C++%20Pawn.md)  
[[2020-05-08_22:41:33]] [Coordinate](./Coordinates.md)  