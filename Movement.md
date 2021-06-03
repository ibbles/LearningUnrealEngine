2020-08-24_12:31:46

# Movement


There are movement Components that can be added to Pawns.
Character comes with a Character Movement Component.
Projectile Movement Component is used for things that arc unguided through the air.

It is common to create *Input Events* that drive the Movement Component.
The execution starts at an input event in the Event Graph, optionally does some processing, and then calls a member function on the Movement Component.
Example function include *TODO: List here.*.
One can also call the Pawn member function Add Movement Input.
Not sure how that relates to the active Movement Component.

Similar to Add Movement Input, Pawn also has Add Controller Pitch Input, Add Controller Yaw Input, and Add Controller Roll Input.
For a Character, the Add Controller Pitch Input won't work because the Character itself can't be tilted.
Instead enable User Pawn Control Rotation on the Camera.
Then the camera will rotate with the Controller instead of the Character, and the Controller can be tilted.

Many movement functions require a world direction.
Common sources of this world direction is the Pawn itself or its Camera.
Get the forward, right, or up vector from either of these and pass to the movement function.

> CharacterMovementComponent has to be on a Character
> but FloatingPawnMovement can be on whatever

[[2021-05-30_19:28:15]] [Character Movement Component](./Character%20Movement%20Component.md)  
