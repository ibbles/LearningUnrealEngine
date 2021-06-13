2021-06-05_15:59:02

# Sphere trace

A sphere trace is an invisible line from a starting position to an end position checking for collisions along that path.
Compared to a line trace a sphere trace has a width, expressed as a sphere radius.
Some report that sphere tracing with a radius larger than 7 doesn't work.
See comments in [Making Your First Game in Unreal Engine 4 // 4-4 Sensor Trigger by Ryan Laley @ youtube.com](https://www.youtube.com/watch?v=tDve03ITW_E)

There are functions for performing a sphere trace: By Channel, and By Profile, and For Objects.

To run a sphere trace one must specify the *start location*, with is a point in world space sphere the trace should start.
Often Get World Location on some Component in the Actor that is calling the trace function.
It can also be from the camera, for look-at type of interactions.
To get the camera location use Get Player Camera Manager and feed that to Get Camera Location.

The *end location* is often a bit more complicated, since it involves direction and distance computations.
Get the Component's or the camera's rotation and from that call Get Rotation X Vector.
X means forward in Unreal Engine.
Scale/multiply the rotation X vector by how long you want the trace to reach.
Add the start position and the scaled rotation X vector to form the end position for the trace.

The *Trace Channel* decides what the trace can hit.
(
I don't know how this works yet.
)

## Hit result

If something is hit then a bunch of information about that object is provided as output pins on the sphere trace node.

- Hit Actor.
The Actor that the trace hit.

[[2021-06-05_12:42:40]] [Line trace](./Line%20trace.md)  
[[2020-04-11_08:23:56]] [Coordinate system](./Coordinate%20system.md)  