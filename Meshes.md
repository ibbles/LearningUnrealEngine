2020-09-14_16:42:51

# Meshes

There are many classes with the word `mesh` in their names.
There are Actor classes, Component classes and Asset classes.

- `StaticMesh`: A mesh with a fixed triangle makeup.
- `ProceduralMesh`: A mesh with a dynamic triangle makeup.
- `SkeletalMesh`: A mesh with a limited dynamic triangle makeup.

`UStaticMesh` is an asset.
It contains actual triangle data.
It is a visual representation of a model of some geometry.
A Static Mesh has is associated with a collection of Materials.
The Static Mesh contains Material Slots that map triangles to Materials.
Changing the Material associated with a slot changes the Material on all triangles associated with that slot.

`UStaticMeshComponent` is a Component that has a pointer to a `UStaticMesh`.

`AStaticMeshActor` is an Actor that has an `UStaticMeshComponent` as its Root Component.

[[2020-05-10_11:01:04]] [Materials](./Materials.md)  