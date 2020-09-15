2020-08-23_17:00:34

# Stand-alone camera

A Camera can be added to the Level as a stand-alone Actor.
We can view what the camera sees by doing Viewport > Perspective > Placed Cameras and select the camera to view through.
In the camera view mode we can move the camera around with the reguliar navigation controls.
That is, right-click-and-hold to enter camera control mode, mouse-move to look around, and  WASD to move.
Click the eject button in the top-left of the viewport to exit camera control mode.

We can make the free-floating camera the active camera in the Level Blueprint.
Node Graph: `Get Player Controller` > `Set View Target with Blend`.
Drag in the Camera Actor instance from the World Outliner into the Level Blueprint and connect to New View Target.
The PlayerController and the Pawn is unaffected by this, and will continue to be controlled just like before.
We just get a third-person perspective of the scene.

An alternative to `Set View Target with Blend` is `Camera Component` > `Set Active.`
Call `Set Active` on both the old and the new camera, passing false for `New Active` to the old and true to the new.

[[2020-05-08_21:50:52]] [Camera](./Camera.md)