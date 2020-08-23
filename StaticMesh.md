2020-05-08_22:05:51

## StaticMesh

A `StaticMesh` is a mesh in which the triangles and vertices don't move in relation to each other.
A `StaticMesh` is either imported, often from an `.fbx` file, or generated from a `RawMesh`.
A `RawMesh` is created from a list of shared vertex positions and per wedge positing index, normal, tangents, and texture coordinate.
Three wedges make up a triangles and is anchored at a vertex.
The wedge carries the index of the vertex's position, and the normal, tangents, and texture coordinate of the vertex.
A `StaticMesh` contains a number of `RawMesh` in a list named `SourceModels`.
