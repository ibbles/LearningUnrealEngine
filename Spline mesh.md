2021-03-20_10:46:45

# Spline mesh

A spline mesh is a mesh Component that is added between points in a spline.

Add a Spline Component to an Actor.
In the Actor's Construction Script loop over the spline.
The loop can be either over control points or spline length divided by mesh length.
Add a Spline Mesh Component for each iteration.
On the Add Spline Mesh Component one can set a bunch of properties.
One such property is the Static Mesh to render.
(Some of?) These properties can also be set with member functions.
On the Split Mesh Component call `Set Forward Axis` and `Set Start And End`.
The forward axis to set depend on how the Static Mesh is oriented in its local space.
The start and end positions and the tangents are read from the spline.
Either from two consecutive points or from consecutive segment length distances along spline.



[[2021-03-20_08:55:00]] [Spline](./Spline.md)  