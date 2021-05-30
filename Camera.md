2020-05-08_21:50:52

# Camera

A `Camera` is often added to a `Pawn` or a `Character`, but sometimes to the level.
Use a `Pawn` for a free-floating camera and `Character` for something that walks around.
A `Camera` is often attached via a `SpringArm`.
The `Pawn` that the `Camera` is attached to should be be the `Default Pawn Class` in the Game mode.

A camera can also be stand-alone.  
[[2020-08-23_17:00:34]] [Stand-alone camera](./Stand-alone%20camera.md).

A camera can also be attached to a socket.
Make the Camera a child of the Mesh.
Select the socket in the Camera's Details Panel > Sockets > Parent Socket.  
[[2020-08-06_22:51:24]] [Sockets](./Sockets.md)  

A Camera that is part of a Pawn can use the Pawn's (Player?) Controller for it's view direction.
To enable, check Camera > Details Panel > Camera Settings > Use Pawn Controller Rotation.

[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-11_09:24:51]] [Character](./Character.md)  
[[2020-04-11_11:26:21]] [Game mode](./Game%20mode.md)
[[2020-08-06_22:51:24]] [Sockets](./Sockets.md)  
[[2020-08-23_17:00:34]] [Stand-alone camera](./Stand-alone%20camera.md)  
[[2020-12-26_21:45:16]] [Viewport camera controls](./Viewport%20camera%20controls.md)  
