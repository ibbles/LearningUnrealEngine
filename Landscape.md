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
More sections for a given Landscape size will make the landscape able to LOD more aggressively, but will cost more CPU.
Larger sections will allow for less CPU overhead.
Larger landscapes often require larger sections.
LOD is not only done by reducing the triangle count for distant Sections, the engine also automatically generate a normal map from the shape of the Landscape.

Components can be added and removed freely, there is no requirement that the entire Landscape is a rectangle.
Each Component is a rectangle.

The `Fill World` button configures the Landscape hierarchy sizes to some auto-detected values.
No idea how it works or what it prioritizes.

The height samples of a Landscape is manipulated in the Sculpt Mode.
Sculpting involve operations ranging from raising and lowering the height field to applying effects such as erosion or noise.

Sculpting are done using brushes, similar to how Photoshop works.
The Clay Brush uses the average of the height samples under the brush, makes it good for filling in holes or digging holes.
It is possible to paint in layers, for example having fine details in one layer and the bigger shape in another.
Not sure when this is usable. Perhaps to allow changing the general layout of the Landscape while keeping small features such as roads.

Can also paint visibility.
Require that the Landscape material has been set to Masked.
(
What is the name of the setting that should be set to Masked?
)
Invisible portions of the Landscape doesn't have collisions.


## Landscape splines

A spline that can affect the Landscape.
Useful for roads and rivers.

## Landscape Brushes

Not sure what this is.