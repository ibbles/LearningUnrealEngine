2020-11-18_17:39:27

# Niagara

Niagara is the part of Unreal Engine that deals with creating and previewing particle effects.
A particle system is a way to spawn may instances of geometries into the world.

When creating a new system or emitter you are given the choice to create from a template.
Nothing is locked or special in such a system or emitter.

## Reason for new system

Before Niagara there were another particle system called Cascade.
Cascade showing it's age. Inflexible. New effects and behaviors require programming.
Not suitable for a wide range of domains.

Need a new tool that puts more control in the hands of artists.
Artists has the ability to create additional functionality themselves.
More flexibility in what kind of data and data sources can be used to drive the simulation.
Programmable and customizable on every axis.
Improved tools for debugging, visualization, and performance.
Can incorporate data from other parts of the engine.
Support for arbitrary data, from other parts of Unreal Engine or external.
Unobtrusive.
Started with data sharing, expose everything.

## Basic concepts
Niagara consists of several pieces to make it easier to extend share resources between systems.
A Niagara system is something that is added into the world.
Niagara systems contains Niagara emitters.
An emitter can for example be fore sparks, smoke, and flames.

The Niagara system consists of the following core components:
- [[2020-12-03_21:29:00]] [Systems](./Niagara%20systems.md)
- [[2020-12-03_21:34:16]] [Emitters](./Niagara%20emitters.md)
- [[2020-12-03_21:41:31]] [Modules](./Niagara%20modules.md)
- [[2020-12-03_21:50:39]] [Parameters](./Niagara%20parameters.md)
- [[2020-12-26_20:22:38]] [Events](./Niagara%20events.md)

A System holds emitters that together produce an effect.
A Niagara system is configured using Graphs and Stacks.
Their behavior is controlled using modules and there is a stack of modules for each phase of the emitter.
Graphs are flexible and powerful but requires some technical knowledge.
Stacks give at-a-glance overview and are easier to use for less technical users.
Graphs are flexible, stacks are modular and give at-a-glance overview.
Emitters produce and simulate particles.
Modules are created my technical artists and combined into stacks by artists.
Parameters let us provide customizations of an emitter or particle system.
Events are a way to communicate between elements (such as particles, emitters, and systems).
Makes everything optional, can disable stuff used for rendering when not rendering.

Modules speak to data, encapsulate behavior, and stack nicely.
Works like function.
Emitters are containers for modules.
Emitters are single purpose reusable pieces of a larger particle system.
Parameteres can bubble up from modules to the emitter.
Systems hold emitteres.
Modules are graphs.
Emitters are collections of stacks.

Inheritance important to design.
Old tools (Cascade) made reuse difficult.
Overrides can be inserted anywhere.
A system can uncheck a module from an imported emitter.
A system can insert new modules into an imported emitter.

[NiagaraKeyConcepts @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Niagara/NiagaraKeyConcepts/index.html)  

## Data

Expose everything, every piece of data that flows through the system.
Can be changed or acted upon.
Both built-in and user defined data.
All data is part of a namespace, a container for hierarchical data.
Uses namespace paradigm, hierarchical containers.
`Emitter.` namespace, `Particle.` namespace.
A container contains attributes.
A container may contain multiple data items for each attribute, one per particle for example.
The build-in organized conceptually in groups such as Emitter and Particle.
A Parameter Map is used to read and write the attributes.
Read from and write to parameter map.
Parameter map is the particle payload, the data we have asked to come along.
Data can be added to, changed, or removed from the Parameter Map arbitrarily.
Can add arbitrary data to payload.
Produces a flow of data transformations and aggregation.

## Modules

[[2020-12-03_21:41:31]] [Niagara modules](./Niagara%20modules.md)  

## Common attributes

`Particles.Velocity`

`Engine.DeltaTime`


## Emitters

[[2020-12-03_21:34:16]] [Niagara emitters](./Niagara%20emitters.md)  

## System

[[2020-12-03_21:29:00]] [Niagara systems](./Niagara%20systems.md)  


## Rendering

Render modules are added to the red section of an Emitter's Module Stack.
There are:
- Sprint Renderer:
- Mesh Renderer:
- Ribbon Renderer:
- Light Renderer:

An Emitter can have multiple renderers.

The Dynamic Parameter Material node is used to communicate per-particle data from the particle system to the Material.
Dynamic parameter values are set in Niagara with the Dynamic Material Parameters module.
There are four Dynamic Parameter slots and each slot holds four channels.
The slot index to use must match the Details > Param Names > Parameter Index property of the Dynamic Parameter node in the Material.


(
Is this false?
There are Dynamic Parameters bindings in the rendering modules where we bind each Dynamic Parameter to a Particle attribute.
)

### Sprite Renderer

Sprite particles are quads that are always facing the camera.
The Sprite Renderer renders camera facing quads.
They are rendering with the same (almost) kinds of materials as any mesh.

The sprite rotation is in degrees, but there is a dynamic input that converts a `[0..1]` float to degrees.

The Material used by the Sprint Renderer may use texture sampling.
The texture may be a grid texture atlas.
We tell the Sprite Renderer to pass atlas-aware UVs to the Material with:
Sprite Renderer > Sub UV > Sub Image Size.
It is called an "image size" but it's really an image count.
This will make it use the first sub-image in the atlas only.
A sub-image is a assigned to each particle with the Sub UVAnimation module.
Which can be placed in the Particle Spawn group of the module stack.
Writes the `Particles.SubImageIndex` attribute.

#### Flipbook
A common way to render particles is with a flipbook animated texture.
Which is a texture atlas that contains the frames of a looping animation of some object.
Create a Material asset, set its Details Panel > Material > Blend Mode to Masked, add a Texture Sample node bound to the flipbook texture and wire the RGB texture output to Base Color and the alpha to Opacity Mask.
Create a Sprite Renderer in the Emitter.
Set the material to the material we just created.
Set Sprite Rendering > Sub UV > Sub Image Size to the number of frames per side in the texture.
Add a Sub UVAnimation module in Particle Update.
Set the SubUV Animation Mode to Linear to get a steady progressing through the frames.
Set Number Of Frames to the number of sub-images in the texture.
This produces an animation that works but may be a bit choppy.
The Number Of Frames input parameter in Sub UVAnimation module can be increased past the actual number of frames to make the animation run faster and do multiple loops.
An alternative is to scale the SubUV Lookup Index input parameter.
The Sub UVAnimation module by default uses `Particle.NormalizedAge` to decide what the SubUV Lookup Index should be for the current frame.
This can be scaled using a Dynamic Input, simply Multiply Float by some constant and Link Inputs > Particles > Normalized Age.
If the constant is `f` then each particle will do `f` rotations during it's lifetime.

Currently all leafs start on the same frame so they will all rotate in sync.
We can prevent that by giving each particle its own starting frame.
In the Particle Spawn module group add a Set New Or Existing Parameter Directly module.
Click the `+` next to Set Parameters in the Selection Panel with the Set Parameters module selected.
Select Create New Parameter > float.
The new parameter shows up in Parameters Panel > Particle Attributes > NewNiagaraFloat.
Rename to RandomStartFrame.
In the Selection Panel for the Set Parameter module set the value to Dynamic Inputs > Uniform Ranged Float.
Leave the range between 0.0 and 1.0. This means start at any point in the rotation.
Change Particle Update > Sub UVAnimation > SubUV Lookup Index to `(NormalizedAge * f) + RandomStartFrame`.
Where `f` is a literal float. You can make this into a User Exposed parameter if you want. I guess…

An alternative way to get a random value per particle is to use Link Inputs > Particles > MaterialRandom.

We can create a smoother animation with UV Blending.
Enable Sprite Renderer > Sub UV > Sub UV Blending Enabled.
In the Material, replace the Texture Sample node with a Particle SubUV node.
Enable Particle SubUV > Details Panel > Material Expression Particle SubUV > Blend.
Now the Sprite Renderer/Material will load two texture samples per frame and blend between them.
Gives a bit smoother animation, but also a kind of ghosting effect, especially where texels goes from masked to unmasked.

### Mesh Renderer

The size of each particle's mesh is controlled with the Mesh Scale attribute.
The rotation of each particle's mesh is controlled with the Mesh Orientation attribute.
The size is set by the Initialize Particle module, but the orientation is not.
Instead we have the Initial Mesh Orientation Module, which can be added to Particle Spawn.

Mesh Particles are made spinning by adding a Mesh Rotation Force module.
Is accumulated, so consider placing it in Particle Spawn instead of Particle Update.
If so, add an Apply Initial Forces as well.

Mesh Renderer cannot use skeletal meshes, so animations must be done in different ways.
Can create flipbook meshes, a mesh where all positions of e.g. a wing has been modeled.
A Material with an opacity mask is used so that only one of the wing models get an on-mask.
The mask is created using a panning texture where the Time input pin is connected to `floor(Time * 7) / n` to get  an `n`-stepped sequence from 0.0 to 1.0.
The mask texture itself is `n-1` black texels and one white.
Multiply the diffuse color texture's alpha channel with the panned 1/0 mask and link to Opacity Mask.


### Ribbon Renderer

Renders a spline between particles that have the same Ribbon ID attribute value.
(
Easy in principle, but weird stuff with flickering and ribbons phasing in and out of reality always seems to happen for me.
)

Taking particle positions, drawing trail of geometry through those positions, creating a strip.

There is an Initialize Ribbon module.

### Light Renderer

Uses the color of the particle.


### Materials

A Niagara Material is created in exactly the same way as any other Material.
There are some things we can do in the Material that is Niagara-specific.
One is the Details > Usage > Used with Niagara (Sprites|Ribbons|Mesh Particles).
Will be automatically enabled when the material is selected in a Niagara render module.
One is the `Particle Color` node, which is given its value from the `Particles.Color` attribute.


[[2020-05-10_11:01:04]] [Materials](./Materials.md)  

## Events

[[2020-12-26_20:22:38]] [Niagara events](./Niagara%20events.md)  

## Data interfaces

[[2020-12-26_20:25:00]] [Niagara data interfaces](./Niagara%20data%20interfaces.md)  

## GPU particles

A particular Emitter is either spawning CPU or GPU particles.
This is selected in Tmitter Properties > Emitter > Sim Target.
Select CPUSim or GPUCompute Sim.

GPU particle systems should have a fixed bound.
This is because the CPU needs to know where the particles might be but that information is only on the GPU.
If there are particles outside of the bounds then those may be popping as the smaller bounds is transitioning in and out of view.
Set in the Emitter or System properties, and can be visualized with the Bounds button in the Emitter Tool Bar.
The Tool Bar button has a sub-button that sets the bound to the current particle space volume.

GPU particles does not support:
- Attribute Reader. (Fixed in 4.26?)
- Events.

## Debugging

The Attributes Spreadsheet is used to view all attributes within the current emitter.

Using a Sprite Renderer we can write numbers as text on the particles.
Text rendering is handled by a Material, so create a new Material for this.
Create a new instantiation of the Sprite Renderer module.
In the Sprite Renderer assign the debug Material.
A Dynamic Material Parameter is used to pass the number to print to the Material.
There are four Dynamic Material Parameters and each contains four floats.
We set the Dynamic Material Parameters in Niagara using the Dynamic Material Parameters module.
In the Material create a Dynamic Parameter node, feed the X, Y, and Z values to an `Append Many` node, and then to a `Debug Float 3 Values`.
Feed the Color output to the materials Emissive Color and the Grey Scale Output to the Opacity Mask output.
The Material's Blend Mode should be set to Masked.
Some tweaking in the material may be required to make it readable.
For example, the Sprite Size binding can be bound to a dedicated debug sprite attribute to control the size of the debug rendering independent of the souce particle's size.




[Niagara/Overview @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Niagara/Overview/index.html)  
[Events and Event Handlers Overview @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Niagara/EventHandlerOverview/index.html)  
[Niagara how-to @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Niagara/HowTo/index.html)  
[VFX and Particle Systems @ learn.unrealengine.com](https://learn.unrealengine.com/course/2547426/module/5502400)  

[Diving Into Niagara: Intelligent Particle Effects | Unreal Fest Online 2020 by Unreal Engine @ youtube.com](https://youtu.be/oX6uiPWXJDY?t=1654)  
[Advanced Niagara Effects | Inside Unreal by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=31GXFW-MgQk)  
[Introduction to Niagara | Unreal Fest Europe 2019 by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=2CtBa3zEaYU)  
[Building Effects with Niagara and Blueprint | GDC 2019 by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=etSfYfIIoSE)  
[Programmable VFX with Unreal Engine's Niagara | GDC 2018 by Unreal engine @ youtube.com](https://www.youtube.com/watch?v=mNPYdfRVPtM)  

[Niagara by tharlevfx @ youtube.com](https://www.youtube.com/playlist?list=PLHjQE2fLIZu97z7Iwf-PjV2e1Y4_k2GKL)  

