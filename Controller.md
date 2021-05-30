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


## Control rotation

A Controller has a Control Rotation, which is the viewing direction.
This is/can be separate from the Pawn's forward direction.
Inputs, such as mouse movements, can be configured to manipulate the Controller's Control Rotation.
Some Components in the possessed Pawn can be configured to rotate along with the control rotation.
This is set with `bUsePawnControlRotation` on those components.
Components that supports this are (at least) Camera, Spring Arm, and Pawn.
I assume this overrides any rotation computed from either the Scene Component hierarchy or any socket attachments.

For the Pawn we can enable or disable controller rotation for roll, pitch, and yaw separately.

It's unclear to me what happens with all four combinations if a Camera is part of a Pawn.
- Camera and Pawn uses controller rotation.
- Camera but not Pawn uses controller rotation.
- Not Camera but Pawn uses controller rotation.
- Neither Camera nor Pawn uses controller rotation.



[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-11_09:24:51]] [Character](./Character.md)  
[[2020-04-11_11:27:52]] [PlayerController](./PlayerController.md)  
[[2020-04-11_11:28:47]] [AIController](./AI%20Controller.md)  
[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  
