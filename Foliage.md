2021-02-06_13:44:25

# Foliage

## Foliage tool
Foliage is a tool to quickly and semi-randomly place a large number of Static Meshes.
Often used to place trees, bushes, flowers, and grass.
Can also be used to place other types of clutter.

It has a dedicated Editor Mode, selected from the Modes Panel or the Tool Bar.
In the tab for that mode there is a Panel listing all the Static Meshes that can be added as part of the foliage.
Drag Static Mesh assets from the Content Browser to that Panel to include them.
Instances of these meshes will be created when foliage is painted into the viewport.

The Foliage tool acts like a brush used to paint the selected Static Meshes onto geometry.
Hold Shift while painting to remove instead of add mesh instances.

You can chose particular mesh assets to *include or exclude* per brush stroke by checking or unchecking the mesh's checkbox in the Static Mesh list in the Foliage Panel.

When a mesh asset is selected, which is not the same as checked, settings for that mesh can be set in the Details Panel below the mesh asset list.
Changes made here will only be applied to instances painted after the change, already existing meshes will be untouched.

*Density* control how dense the meshes will be placed when painting.
There are two density settings, one in the Tool Bar and one in the per-mesh settings.
The Tool Bar density is a number between 0 and 1 that scales the per-mesh densities.
The per-mesh density is the number of mesh instances that will exist per "unit" area.
Unit here doesn't mean 1, but 1000x1000 Unreal Units, or 10x10 m.

*Radius* is the minimum distance between two mesh instances.
I don't know if this is per mesh type in the foliage, independent of the other mesh types, or if any instance, regardless of type, is checked when painting.
I don't know what will happen if the radius is set so large that the density target cannot be reached.
I assume that radius wins over density, i.e., if there is no available spot to put an instances because all the space is covered by instance circles then no new instance will be placed even though the density target hasn't been reached yet.

The *scale* of a mesh asset can be set by selecting that mesh asset in the mesh list, setting Painting > Scaling to Free, and editing the Scale X, Scale Y, and Scale Z ranges.

To paint on steep inclines of the side of cliffs, the *Ground Slop Angle* must be increased.
If multiple mesh assets are selected in the mesh asset list then one of each will be placed at the clicked location.

Individual instances can be placed with the *Single* tool from the Tool Bar.
Individual instances can also be removed with this tool by holding Shift and clicking.
One must click on the ground where the instances was spawned, not on the mesh itself.


## Grass Landscape layer

Another way to create grass is to make it part of a Landscape material.
The Landscape material can have a Grass output node.
Input to the Grass output node can be a sample from a Grass layer on the Landscape.
The grass layer contains a collection of Grass Types, each of which has a Landscape Grass Type, which in turn has a Grass Mesh.
Wherever the Grass layer has been painted on the Landscape, the Grass mesh will be rendered.
The Landscape Grass Type also has information such as density and size and such.
Good for performance because the grass mesh will use pre-baked lighting information from the Landscape.


## Procedural Foliage Volume

Automatic placement of foliage within a volume.
Has rules for how plants spread and while types of plants does or doesn't grow next to other types.
Such as only some kinds of flowers grow in that shadow of some kind of trees.


[[2020-12-03_10:41:49]] [Editor mode](./Editor%20mode.md)  
[[2020-05-08_22:05:51]] [Static Mesh](./Static%20Mesh.md)  
[[2021-05-31_20:28:03]] [Instanced Static Mesh](./Instanced%20Static%20Mesh.md)  