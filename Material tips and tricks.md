2021-06-03_21:41:00

# Material tips and tricks

## Wind

A wind effect can be created using the World Position Offset input on the Material node.
World Position Offset moves vertices from the position that vertex has in the source mesh asset.
There is a helper node for wind: Simple Grass Wind.
It has three (four?) parameters:
- WindIntensity: float. How strong the wind should be.
I think the same value should be passed to all vertices in a mesh.
- WindWeight: float. Wind influence in this particular vertex.
I think this is the way we control how strong the effect of the wind is on particular points on the mesh.
For example, on a tree the weight should be very low near the root, low for the trunk, and increases as we move farther and farther out along the branches, twigs, and leaves.
This values can be produced by an artist using a vertex colors or generated from e.g., Local Position or the vertex's texture coordinate.
Your mileage may vary on the latter two.