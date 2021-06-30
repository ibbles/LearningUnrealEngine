2021-03-20_10:46:45

# Spline mesh

A Spline Mesh is a type of Mesh Component that can be added between points in a spline.

Has a Static Mesh Asset that will be placed between the two control points.
The mesh must be segmented for the bending/curving to work.

Spline Mesh Component has two important functions:
- `Set Forward Axis`
This tells the Spline Mesh Component which way the Static Mesh Asset is oriented.
I don't know what the Update Mesh parameter does.
  - `Set Start and End`
Set where in the world the mesh will begin and end, and with what tangents.
These can come from anywhere, but reading them from a spline is common.

It also has a `Set Static Mesh` function, but it doesn't work in Unreal Engine 4.25.
Instead select the `Add Spline Mesh Component` node and set the Static Mesh in the Details Panel.
This makes it impossible to pass a mesh from an Actor variable to the Spline Mesh Component.

The Material assigned to a Spline Mesh must have `Use with Spline Mesh` checked in the Details Panel.
(
TODO: Find out where the checkbox really is, and describe better.
)

Add a Spline Component to an Actor.
In the Actor's Construction Script loop over the spline.
The loop can be either over control points or spline length divided by mesh length.
Loop with a regular For Loop, not For Each Loop.
Add a Spline Mesh Component for each iteration, using the Add Spline Mesh Component node.
In the Details Panel for the Add Spline Mesh Component one can set a bunch of properties.
One such property is the Static Mesh to render.
(Some of?) These properties can also be set with member functions.
On the Spline Mesh Component call `Set Forward Axis` and `Set Start And End`.
The forward axis to set depend on how the Static Mesh is oriented in its local space.
The start and end positions and the tangents are read from the spline.
Either from two consecutive points or from consecutive segment length distances along spline.
Use Get Location At Time, Get Location at Spline Point, or Get Position at Distance Along Spline.
The Time variants goes from 0.0 to the value assigned to Duration on the spline, 1.0 by default.


[[2021-03-20_08:55:00]] [Spline](./Spline.md)  