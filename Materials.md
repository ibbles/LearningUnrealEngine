2020-05-10_11:01:04

# Materials

A `Material`, or a set of materials, is what defines the colors an object has and how light interacts with the object.
Materials define the look of a surface or volume.
This can be a `StaticMesh` or a sprite.

A `Material` is a blueprint and all `Materials` have a `Result Node` that define the properties of the material.

## Common nodes and tips-and-tricks

Component Mask is used to pick out a subset of the channels of color. Often to drop alpha.
Wires can be moved between pin by holding Ctrl and click+drag.
Colors are made darker by multiplying by a scalar < 1.0. Not sure how to avoid also scaling alpha.
Constants and parameters are created by holding 1, 2, or 3 and clicking in the graph.
Constants are converted to parameters by right-click > Convert to Parameter.
Materials are made double-sided, or two sided, using a checkbox in Details Panel > Material > Two Sided.
There is a node named GeneratedBand. Useful for creating sliding band effects when combined with a Panner.

The Dynamic Parameter node is used to pass per-frame state to the material.
Each Dynamic Parameter can accommodate four floats.
Each channel can have each own name.

[[2020-08-24_10:55:42]] [Material Editor](./Material%20Editor.md)  
[[2020-08-11_11:11:52]] [Material instance](./Material%20instance.md)  
[[2020-08-11_19:05:49]] [Material parameter collection](./Material%20parameter%20collection.md)  
[[2020-05-08_22:05:51]] [Static Mesh](./Static%20Mesh.md)  
[[2020-12-26_21:50:52]] [Skeletal Mesh](./Skeletal%20Mesh.md)  
[[2020-12-28_15:11:08]] [Material shading model inputs](./Material%20shading%20model%20inputs.md)  

[[2020-08-11_11:13:52]] [UMaterialInstance](./UMaterialInstance.md)  
[[2020-08-11_13:53:42]] [UMaterialInstanceConstant](./UMaterialInstanceConstant.md)  
[[2020-08-11_13:53:57]] [UMaterialInstanceDynamic](./UMaterialInstanceDynamic.md)  
