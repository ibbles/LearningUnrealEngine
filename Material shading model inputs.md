2020-12-28_15:11:08

# Material shading model inputs

- Metallic : `float`
    Value between 0.0, and 1.0. Determines how metallic the surface is. Affects reflections. Usually 0.0 or 1.0. Semi-metallic materials are uncommon.
- Specular: `float`
    How shiny the material is, i.e., how much light it reflects. 0.0 means no light reflectance while 1.0 means maximum reflectance.
- Roughness: `float`
    Determine the roughness/sharpness of the reflection. A high roughness produces a scattered and less prominent reflection. A low roughness will produce a more mirror-like surface.
- Emissive color: `Vector`
    Glow color. Can take colors more saturated than 1.0 for stronger light. Does not actually emit any light, i.e., will not illuminate surrounding objects.
- Normal: `Vector`
    I don't know what space the normal is in. What does it mean if the passed normal is e.g., the X-axis, the Y-axis, or the Z-axis. Is there a well-defined "outwards" direction that is the same everywhere? Is the normal an offset from the mesh normal, or does it override it? Often read from a texture, called a Normal Map. 
    

[[2020-08-24_10:51:04]] [Shading models](./Shading%20models.md)  
[[2020-08-24_10:55:42]] [Material Editor](./Material%20Editor.md)  