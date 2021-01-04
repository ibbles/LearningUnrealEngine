2020-04-11_09:24:51

# Character

A type of pawn.
Used for humanoid things that walk, run, jump, and similar.
Has a Capsule, used for collision detection, as its Root Component.
Has an Arrow, to show the forward direction which is along the X axis.
Has a Skeletal Mesh for the visual representation and (possibly) ragdoll physics.
Has a Character Movement Component for handling movement.
The Character Movement Component controls how the character can walk/run/jump/etc.
Controller inputs are forwarded to the Character Movement Component.
Knows if it is walking/running/swimming/falling/etc.
The Character has a Player Controller. Not sure what this means.

The Character Movement Component is "hidden".
Not really hidden, but used through high-level input member functions on Pawn.
Functions such as `AddMovementInput`.



[[2020-03-10_21:29:17]] [Actor](./Actor.md)  
[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-11_11:18:18]] [Controller](./Controller.md)  
[[2020-12-26_21:50:52]] [Skeletal Mesh](./Skeletal%20Mesh.md)  
[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  
[[2021-01-03_17:40:41]] [C++ Character](./C++%20Character.md)  
