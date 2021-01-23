2020-08-10_20:20:28

# Animation Blueprint

Characters (or one of it's ancestor classes) have the Animation property category.
One property within that category is Anim Class.
Used to create animation logic for character.
The Event Graph is used to update the internal state of the character.
The internal state is used to drive the current animation pose the character is in.
The Anim Graph is used to define the animation poses.
Is used to blend between animations.
Update moment-to-moment variables at runtime. 
Contains a state machine, where each state may correspond to an animation pose.
The AnimGraph defines the moment-to-moment Final Animation Pose at runtime.

[[2021-01-04_19:23:55]] [Animation](./Animation.md)  
