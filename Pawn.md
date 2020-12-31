2020-04-11_09:21:04

# Pawn

A Pawn is a type of Actor that can be controlled.
By a player with a controller, or by an AI.
We say that the Pawn is possessed by the controller.
Can be a character, a vehicle, a fish, etc.
Often comes with a CameraComponent which the player sees through while controlling the pawn.
The Game Mode has a default Pawn.

The Pawn has a set of input events that it listens for and reacts to.
Inputs such as key or button presses, mouse clicks and drags, thumb sticks, and triggers.
Unreal Engine maps these device inputs to named input events.
The device input to input event mapping is done in Top Menu Bar > Edit > Project Settings > Engine > Input > Bindings.

[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  

`SetupPlayerInputComponent`

## Free-floating top-down view Pawn

For e.g., a RTS or RPG game.
A simple player controlled Pawn is created from a StaticMesh, a SpringArm, and a Camera.
Attach the SpringArm to the StaticMesh and the Camera to the pringArm.
Position and rotate the StaticMesh until you get the view point you want.
The StaticMesh is often a sphere.
I don't know what the purpose of the StaticMesh is.



[[2020-03-10_21:29:17]] [Actor](Actor.md)  
[[2020-04-11_09:24:51]] [Character](./Character.md)  
[[2020-04-11_11:18:18]] [Controller](./Controller.md)  
[[2020-04-11_11:26:21]] [Game mode](./Game%20mode.md)  
