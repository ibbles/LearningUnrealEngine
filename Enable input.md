2021-06-05_12:17:19

# Enable input

Input can be enabled for an Actor instance that isn't the one possessed by the Player Controller.
That means that the input events created in that Actor's Event Graph will be considered when the engine detect a hardware input event.
Enable input for an Actor by calling the Enable Input function.
Pass in the Actor to the first input pin and the Player Controller that should have control over the Actor to the second input pin.
Get a reference to the Player Controller using Get Player Controller.
You must know which player, i.e., the Player Controller index, that should be given control over the Actor.

Disable input again by calling Disable Input with the same parameter.

To add input events that can be triggered while an Actor has input enabled, right click the Event Graph background and search for any of the events listed in Project Settings > Engine > Input > Bindings.
You can also add raw keyboard, mouse or gamepad events.

This is one way to create generic interactable objects in the level.
Create Actors that have a collision box.
On Begin Overlap, test if Other Actor is the player Pawn and if so enable input on the Actor.
The test can be done either with an Equals node and Get Player Pawn/Character or a cast to the Pawn type used for the player.
The Actor has the Interact event in its Event Graph which does whatever logic the interaction should do.
On End Overlap, test if Other Actor is the player Pawn and if so disable input on the Actor.
This approach won't work well when multiple interactable objects overlap.
A short line trace may work better in this case.

[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  
[[2020-04-11_11:27:52]] [PlayerController](./PlayerController.md)  
