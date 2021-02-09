2021-02-09_19:17:57

# Decals

A Decal is an image that is projected onto geometry.
The image is actually a Material with the Material Domain set to Deferred Decal.
To project an actual image do a texture sample in the Material.
The texture coordinates seen within the material as 0..1 in the bounding volume of the decal, not the mesh being projected on.
