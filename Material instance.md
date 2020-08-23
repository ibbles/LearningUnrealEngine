2020-08-11_11:11:52

# Material Instance

A Material Instance is a material that inherits the Material Graph from a base/parent material.
The base/parent material exposes parameters that the Material Instance can set.
The parameters usually influence the result of the Material Graph somehow.
For example by setting a color, size of something, rate something changes, etc.
Parameters can be `float`, `Vector2`, `Vector3`, `Texture`, etc.
Materials are assigned to `StaticMesh`s just like regular materials.
