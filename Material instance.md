2020-08-11_11:11:52

# Material Instance

A Material Instance is a material that inherits the Material Graph from a base/parent material.
The base/parent material exposes parameters that the Material Instance can set.
The parameters usually influence the result of the Material Graph somehow.
For example by setting a color, size of something, rate something changes, etc.
Parameters can be `float`, `Vector2`, `Vector3`, `Texture`, etc.
Material Instances are assigned to `StaticMesh`s and similar just like regular materials.

Create a new Material Instance by right-click the parent material and select Create Material Instance.
Material Instance names of often prefixed with `MI`.
The Material Instance Editor does not show the Material Graph.
Instead it lists the base material's parameters in the Details Panel.
To override a parameter the checkbox next to it must be checked.

One advantage of Material Instances is that they are incredibly quick to update.
Changes can be seen in the Level Viewport almost immediately after updating a parameter in the Material Instance Editor.

The parameter values set in a Material Instance can be changed at runtime.

[[2020-12-28_16:10:42]] [Material parameter](./Material%20parameter.md)  
