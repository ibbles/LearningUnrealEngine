2021-03-20_08:55:00

# Spline

A Spline is an Actor Component, which means that it is added to Actors.

The `Get Spline Length` method returns the length of the spline in cm.
The `Get Location at Distance Along Spline` returns a world or local location given distance.
The `Get Rotation at Distance Along Spline` returns a world or local location given distance.

A common way to use a spline is to have a 0..1 value, for example from a Timeline, multiply that with the spline length, and feed the result to the get location or get rotation method.

The shape of the spline is defined by control points.
Gray points are location points.
Orange points are tangent points that define the spline's curvature.
Each tangent point is associated with a location point.
Control points can be moved and rotated with the regular manipulation tools.
New control points are created by Alt+left-drag on one of the arrows when a control point is selected.

The forward direction at a point on the spline, as reported by the Get Rotation methods, is defined not by the orientation of the control points but by the line between the points.



[[2020-04-11_08:29:46]] [Object placement and positioning](./Object%20placement%20and%20positioning.md)  
[[2021-03-20_09:31:05]] [Timeline](./Timeline.md)  
[[2021-03-20_10:46:45]] [Spline mesh](./Spline%20mesh.md)  