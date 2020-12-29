2020-04-11_08:59:35

# Lighting

## Types of light sources

Unreal Engine has a few different types of lights.
- Point
    Emanates from a single point in all directions.
- Spot
    Directional and has an orientation.
    The shape is defined by two cones, one inner and one outer.
    The inside of the inner code is fully lit/has full light intensity.
    The shell between the inner cone and the outer cone has fading intensity from the inner to the outer.
    Outside the outer cone there is no light.
 - Directional
    Simulates sunlight, an infinite volume of parallel light rays.
    Moving a directional light has no effect, but rotating does change the light's angle of attack.
- Sky
    Provides scene-specific ambient light using a cube map, either as a texture or as a scene capture.

## Light properties

- Intensity [cd]: Luminous intensity.
    The "density" of the light. How much light energy there is per unit solid angle. How strong each light ray is.
- Color: The color of the light.
- Attenuation radius [cm]: Culling distance.
    Objects farther than the attenuation radius away will ignore this light. Has no effect on objects well within the attenuation radius. There seems to be some form of interpolation near the edge of the attenuation radius.

## Light mobility

- Static: Cannot move or change intensity or color during runtime.
- Stationary: Cannot move. Can change intensity and color.
- Movable: Can move and change color and intensity during runtime.

Light mobility can have a large impact on performance, so chose the most restrictive possible for each light.

Non-dynamic lighting must be built.
This is done from the Level Editor Tool Bar.

Some types of lights can be either be inverse square falloff or not.
Inverse square falloff is more realistic but requires large luminance and radius values.
Linear square falloff (which I assume the alternative is) can be easier to control.

[[2020-04-11_08:47:51]] [[col] Lighting](./[col]%20Lighting.md)  