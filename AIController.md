2020-04-11_11:28:47

# AIController

A type of controller that uses AI to generate input signals.
Created as a Blueprint or C++ class with `AIController` as the  parent class.
An AIController controls a Pawn, accessed with `GetControlledPawn`.
A Pawn selects its AI Controller Class in the Pawn section of the Details panel.
The property is named 	`AI Controller Class`.
There is also`Auto Possess AI`. There are three options:

- Placed in World. When placed in Unreal Editor, I think.
- Spawned. When spawned during game play. I think.
- Placed in World or Spawned.
- Disabled. No auto-possessing. The Pawn won't have an AI until someone gives it one.

The AIController has a weak relationship to its Pawn, meaning that the two can exist separately.
The AIController is notified of the Pawn it controls with the `OnPossess` callback.
`BeginPlay` may be too soon, may not have possessed the Pawn yet.

Can contain a Blackboard to store  state. Enable with the `Use Blackboard` function.
Select the Blackboard asset to use. Often called from the BeginPlay event.

A Behavior Tree is started by adding a `Run Behavior Tree` node. Select the behavioral tree asset to use. Often called from the BeginPlay event.

[[2020-04-11_11:18:18]] Controller
[[2020-04-11_09:21:04]] Pawn
[[2020-07-04_16:38:27]] Blackboard
[[2020-07-04_15:46:00]] Behavior tree