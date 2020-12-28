2020-08-24_10:51:04

# Shading Models


The Shading Model define what the outputs of the Material Graph mean, how they are transformed into a final pixel color.
Unreal Engine comes with a set of Shading Models.
Each Shading Model gives a separate *look* for the material.

- Unlit  
    Emissive color only. Looks like it's glowing. Does not receive light from other lightsources and does not emit any light of its own onto other objects. Special effects, such as Dirt Mask, may pick up the emissive color and enhance the glow effect.
    The Material Graph can also set World Position Offset and Pixel Depth Offset.
- Default Lit  
    The default Shading Model. Includes direct lighting, indirect lighting, and specular reflections.  
    The Material Graph can set Base Color, Metallic, Specular, Roughness, Emissive Color, Normal, World Position Offset, Ambient Occlusion, and Pixel Depth Offset.
- Subsurface  
    Simulates subsurface scattering. Has a Subsurface Color input, which is the color of the material just below the surface. This is dark red for human skin and dark blue-green for ice.
    The Material Graph can set Base Color, Metallic, Specular, Roughness, Emissive Color, Opacity, Normal, World Position Offset, Subsurface Color, Ambient Occlusion, Pixel Depth Offset.
- PreIntegrated Skin  
    A low-cost version of the Subsurface shading model designed for human skin. Has the same parameters as Subsurface.
- Subsurface Profile  
    A high-quality version of the Subsurface shading model designed for human skin.
    The Material Graph can set Base Color, Metallic, Specular, Roughness, Emissive Color, Opacity, Normal, World Position Offset, Ambient Occlusion, Pixel Depth Offset.
- Two Sided Foliage  
    A subsurface variant designed for thin materials such as leaves. More about light transmission than reflected subsurface scattering.
    The Material Graph can set Base Color, Metallic, Specular, Roughness, Emissive Color, Normal, World Position Offset, Subsurface Color, Ambient Occlusion, Pixel Depth Offset.
- Clear Coat  
    Used for multiplayer materials with a thin translucent layer over a standard material. The documentation does not provide a parameter list.
- Dual-Normal Clear Coat  
    Variant of Clear Coat that adds a normal for the subsurface layer.
    The Material Graph can set Base Color, Metallic, Specular, Roughness, Emissive Color, Normal, World Position Offset, Clear Coat, Clear Coat Roughness, Ambient Occlusion, Pixel Depth Offset.
    It's unclear to me where the subsuface layer normal is set.
- Hair  
    Used to render hair. Supports multiple specular highlights: one for the light color and another for light+hair color.
    The Material Graph can set Base Color, Scatter, Specular, Roughness, Emissive Color, Tangent, World Position Offset, Backlit, Ambient Occlusion, Pixel Depth Offset.
- Cloth  

[[2020-05-10_11:01:04]] [Materials](./Material.md)


[Lighting Models @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Rendering/Materials/MaterialProperties/LightingModels/index.html)