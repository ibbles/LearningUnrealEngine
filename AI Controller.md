2020-04-11_11:28:47

# AI Controller

A type of controller that uses AI to generate input signals.
Created as a Blueprint or C++ class with AI Controller as the  parent class.
An AI Controller controls a Pawn, accessed with `GetControlledPawn`.
A Pawn selects its AI Controller class in the Pawn section of the Details panel.
The property is named `AI Controller Class`.
There is also`Auto Possess AI`.
There are two possible possession events, Placed and Spawed, so four combinations:

- Placed in World.
    When placed in Unreal Editor, I think. So instances that exists when the level is loaded but not instances that are created during gameplay.
- Spawned.
    When spawned during gameplay. I think.
- Placed in World or Spawned.
    Both of the above combined.
- Disabled.
    No auto-possessing. The Pawn won't have an AI until someone gives it one.

The AI Controller has a weak relationship to its Pawn, meaning that the two can exist separately.
The AI Controller is notified of the Pawn it controls with the `OnPossess` callback.
BeginPlay may be too soon, may not have possessed the Pawn yet.

Can contain a Blackboard to store  state. Enable with the `Use Blackboard` function.
Select the Blackboard asset to use. Often called from the BeginPlay event.

A Behavior Tree is started by adding a `Run Behavior Tree` node. Select the behavioral tree asset to use. Often called from the BeginPlay event.

[[2020-04-11_11:18:18]] [Controller](Controller.md)  
[[2020-04-11_09:21:04]] [Pawn](Pawn.md)  
[[2020-07-04_16:38:27]] [Blackboard](Blackboard.md)  
[[2020-07-04_15:46:00]] [Behavior tree](Behavior%20tree.md)  
