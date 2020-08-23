2020-04-11_11:27:52

# PlayerController

A type of controller that reads input from the player, i.e., a game pad, keboard, mouse, joystic, or similar.
A `PlayerController` have access to the `Pawn` it is controlling through the `GetPlayerPawn` function.
The `Pawn` is often of a known subclass whose type has been defined in the selected `GameMode`.
The `PlayerController` Blueprint often has a variable of the subclass type that is set in `BeginPlay`.
`GetPlayerPawn`→`CastTo<Type>` → `SetVariable`.
The events that the `PlayerController` can receive are listed in `ProjectSettings` → `Engine` → `Input`.
Each `ActionMapping` and `AxisMapping` corresponds to one event in the `PlayerController`.
Event start execution nodes are created by right-click and type the name of the event, i.e., `MoveForward`, or `TurnLeft`.
To find the world direction of the `Pawn`'s forward vector we do `GetActorTransform`→`TransformDirection` passing in the unit X vector, since the X axis is forward in Unreal Engine.
If the vector is a displacement then the new position is found by adding, with a `+` node, the transformed displacement to the `Location` property after breaking the `Transform`.
The result of the add, i.e., the new `Location`, is written back to a new `Transform` using a `Make Transform` node.
Just copy over the `Rotaion` and `Scale` from the old `Transform` to the new one.
The new `Transform` is applied to the `Actor` with `SetActorTransform`.


[[2020-04-11_11:18:18]] Controller
[[2020-04-11_11:28:47]] AIController
[[2020-04-11_11:26:21]] Game mode
[[2020-04-10_21:46:17]] Inputs
[[2020-05-08_22:41:33]] Coordinates