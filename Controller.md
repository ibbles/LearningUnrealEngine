2020-04-11_11:18:18

# Controller

Drives a Pawn.
Two kinds: Player Controller and AI Controller.
User interacting with the keyboard, mouse, or gamepad causes events to fire in the Player Controller.
A Player Controller shouldn't listen to all input events.
When possessed, input events that the Player Controller doesn't handle are instead passed to the Pawn.
The Player Controller hold input functionality for the game.
The Player Controller sends generic signals out to the `Pawns`.
An AI Controller is a brain that you can plug into a `Pawn`.

A Controller has a Control Rotation, which is the viewing direction.
This is/can be separate from the Pawn's forward direction.
Inputs, such as mouse movements, can be configured to manipulate the Controller's Control Rotation.
Some Components in the possessed Pawn can be configured to rotate along with the control rotation.
This is set with `bUsePawnControlRotation` on those components.
Components that supports this are Camera and Spring Arm.



[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-11_09:24:51]] [Character](./Character.md)  
[[2020-04-11_11:27:52]] [PlayerController](./PlayerController.md)  
[[2020-04-11_11:28:47]] [AIController](./AIController.md)  
[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  
