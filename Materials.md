2020-05-10_11:01:04

# Materials

A `Material`, or a set of materials, is what defines the colors an object has and how light interacts with the object.
Materials define the look of a surface or volume.
This can be a `StaticMesh` or a sprite.
A `Material` is a node graph and all `Materials` have a `Result Node` that define the properties of the material.
Materials are assets, and can be found in the Content Browser.
A Material can be assigned to a mesh by dragging it from the Content Browser either onto the mesh in the viewport or to one of the material slots in the mesh instance's Detals Panel.

## Common nodes and tips-and-tricks

Component Mask is used to pick out a subset of the channels of color. Often to drop alpha.
Wires can be moved between pin by holding Ctrl and click+drag.
Constants and parameters are created by holding 1, 2, or 3 and clicking in the graph.
Constants are converted to parameters by right-click > Convert to Parameter.

By default triangles in Unreal Engine are one-sided, meaning that back-face culling is enabled.
The effect of this is that objects become invisible when viewed from the inside or backside for single-sided objects.
We can make them two-sided, also called two sided, double-sided, or double sided.
Check the checkbox in Material > Output Node > Details Panel > Material > Two Sided.

Colors are made darker by multiplying by a scalar < 1.0. Not sure how to avoid also scaling alpha.

There is a node named GeneratedBand. Useful for creating sliding band effects when combined with a Panner.

The Dynamic Parameter node is used to pass per-frame state to the material.
Each Dynamic Parameter can accommodate four floats.
Each channel can have each own name.

### Normals

The default normal in a material i (0, 0, 1).
This represents the normal in the mesh.
We can scale normals from a normal map by lerping between (0, 0, 1) and a texture sample from the normal texture.
When we are close to (0, 0, 1) the effect of the normal map is very weak.
When we are close to the texture sample the effect of the normal map is very strong.

The computed normal passed to the material output node is available to other parts of the material using the PixelNormalWS node.
WS stands for World Space.

### Sphere mask

Produce a fall-off based on where two vectors overlap.
Can be used to produce a circular fall-off at the half-way point of a texture.

Another way to do a circular fall-off with with
```
Camera Vector > TransformVector World Space to Tangent Space > Mask(B)
```
On a sphere this produces white in the center and black around the perimeter.
The distribution between "center" and "perimeter" can be controlled by passing the output of `Mask(b)` into the Base input of a Power node.

### Motion_4WayChaos

Continuously distort a texture in multiple layers.

[Shaders in UE4 | Live Training | Unreal Engine Lievestream @ YouTube](https://www.youtube.com/watch?v=mig6EF17mR8)


[[2020-08-24_10:55:42]] [Material Editor](./Material%20Editor.md)  
[[2020-08-11_11:11:52]] [Material instance](./Material%20instance.md)  
[[2020-08-11_19:05:49]] [Material parameter collection](./Material%20parameter%20collection.md)  
[[2020-05-08_22:05:51]] [Static Mesh](./Static%20Mesh.md)  
[[2020-12-26_21:50:52]] [Skeletal Mesh](./Skeletal%20Mesh.md)  
[[2020-12-28_15:11:08]] [Material shading model inputs](./Material%20shading%20model%20inputs.md)  

[[2020-08-11_11:13:52]] [UMaterialInstance](./UMaterialInstance.md)  
[[2020-08-11_13:53:42]] [UMaterialInstanceConstant](./UMaterialInstanceConstant.md)  
[[2020-08-11_13:53:57]] [UMaterialInstanceDynamic](./UMaterialInstanceDynamic.md)  
