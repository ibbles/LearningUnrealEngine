2021-05-28_23:06:53

# Lightmaps

Used to store light and shadow information in a texture.
A precompute pass is done as part of the cooking process, the result stored in the lightmap textures.
The precompute pass can be time consuming.
The red, green, and blue channels are not used to store colors, but other types of data.
Don't know what yet.
Very performant at runtime.

To use a lightmap the Static Mesh must have lightmap UVs.
These are similar to texture coordinates.
Do not allow for overlaps or coordinates outside of the 0..1 range.
Each point on each triangle must map to a single and unique point in the lightmap texture.
Triangles with lightmap UV coordinates outside of the 0..1 range will not get any lightmap information and thus not light or shadows.
If triangles overlap in the lightmap texture then a shadow that falls on one triangle will also show up on the other.
The lightmap UVs are often stored in the second UV channel.
Some call this Channel 1 (0-based indexing) while others call this Channel 2 (1-based indexing).
Unreal Engine uses 0-based indexing, so the lightmap UVs are at index 1.
The Editor can generate lightmap UVs for your meshes.

Each Static Mesh has its own lightmap texture.
Properties for that lightmap texture is set in the Details Panel of the Static Mesh Editor.
Such as resolution.
Can change the light map coordinate index, if we want something other than the default 1.


## Volumetric lightmaps

Controlled by Lightmass Importance Volume.
Higher-quality lighting within a Lightmass Importance Volume.


[[2020-05-08_22:05:51]] [Static Mesh](./Static%20Mesh.md)  