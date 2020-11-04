2020-10-14_11:16:46

# Landscape

A Landscape is a large height field with materials and a collision surface.

It is hierarchical with three levels:
- Landscape: The entire landscape. Consists of up to 32x32 Components.
- Component: Has a fixed grid of Sections.
- Section: Used for LOD and culling.
- Quad: Flat squares like texels in a texture. Consists of four vertices.
- Vertex: Individual height samples.

Sections are used for LOD and culling.
More sections will make the landscape able to LOG more aggressively, but will cost more CPU.
Larger sections will allow for less CPU overhead.
Larger landscapes often require larger sections.

The `Fill World` button configures the Landscape hierarchy sizes to some auto-detected values.
No idea how it works.

The height samples of a Landscape is manipualted in the Sculpt Mode.
Sculting involve operations ranging from raising and lowering the height field to applying effects such as erosion or noise.

Sculpting are done using brushes, similar to how Photoshop works.
The Clay Brush uses the average of the height samples under the brush, makes it good for filling in holes or digging holes.
