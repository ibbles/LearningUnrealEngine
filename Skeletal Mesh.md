2020-12-26_21:50:52

# Skeletal Mesh

A mesh that in addition to triangles contains a bone structure.
The bones form a hierarchy, a tree structure.
The bones are sometimes called joints.
The bones can be animated to move in predefined sequences.
When one bone is moved the entire subtree rooted at that bone will follow.
The triangles follows the bones as they move in relation to each other.
A Skeletal Mesh can have a number of animations associated with it.

A Skeletal Mesh has a Physics Assets.
A Physics Asset deals with physical reactions such as collisions.
The Physics Assets contains collision geometry for the Skeletal Mesh.
Each collision geometry is associated with one of the bones.



Another type of mesh is the Static Mesh, which doesn't have a bone structure.

[[2020-05-08_22:05:51]] [Static Mesh](./Static%20Mesh.md)  