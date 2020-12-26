2020-11-18_17:39:27

# Niagara

A particle system is a way to spawn may instances of geometries into the world.

## Reason for new system

Cascade showing it's age. Inflexible. New effects and behaviors require programming.
Not suitable for a wide range of domains.
Need a new tool that puts more control in the hands of artists.
Artists has the ability to create additional functionality themselves.
More flexibility in what kind of data and data sources can be used to drive the simulation.
Improved tools for debugging and visualization.

## Basic concepts

The Niagara system consists of the following core components:
- Systems.
- Emitters.
- Modules.
- Parameters.

A Niagara system is configured using Graphs and Stacks.
Graphs are flexible and powerful but requires some technical knowledge.
Stacks give at-a-glance overview and are easier to use for less technical users.
Modules are created my technical artists and combined into stacks by artists.

## Data

Expose everything, every piece of data that flows through the system.
Can be changed or acted upon.
Both built-in and user defined data.
All data is part of a namespace, a container for hierarchical data.
A container contains attributes.
A container may contain multiple data items for each attribute, one per particle for example.
The build-in organized conceptually in groups such as Emitter and Particle.
A Parameter Map is used to read and write the attributes.
Data can be added to, changed, or removed from the Parameter Map arbitrarily.
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

(For 4.25, events only work for CPU particles, not GPU.)

Requires Persistent IDs must be enabled in the Emitter Properties of emitters that use events.
Not sure if this is a requirement on both event triggers and event handlers.

Events are a way to communicate between emitters in a system.
One emitter generates some data and emitters listens for and reacts to that data.
We say that the listening emitter has an Event Handler for an Event.
Both Events and Event Handlers are Modules.
An event trigger can send arbitrary payload, i.e., an attribute container, to the event handlers.
An event handler can run on a particular particle  (by ID) or on every particle.
An event handler can spawn new particles and run on those.
An event handler has it's own execution stack. (Module stack?)
Splitting the logic up between the main emitter stack and a set of event stacks help with organization.
There are built-in events for collision, death, and location.

### Location Events

Location events are enabled by adding a Generate Location Event module to the Particle Update group in an emitter.
Particles spawned by that emitter will continuously generate location events.
The location event has a payload that contains a bunch of attributes or the particle.
Position, Velocity, and normalized age, for example.
The payload attributes can be linked to any attribute.

### Death events

Generated by placing a Generate Death Event module in the Particle Update group.
The event is triggered at the end of each particle's lifetime.

### Collision events

Generated by placing a Generate Collision Event module in the Particle Update group.
The event is triggered when a particle collides with an Actor, such as a Static or Skeletal Mesh.
Collision events can only be generated if collision data is available.
Collision data is generated by the Collision module.
The Collision module must be above the Generate Collision Event module in the module stack.

### Event Handlers

Event Handlers are added to Emitters.
An Event Handler consists of an Event Handler Properties and a Receive Event module.
The Event Handler Properties decide what event source the handler should listen to.
You can bind tho any event in any Emitter in the System.
The Receive Event module is the code that is executed when the event is triggered by the source.
You need such a pair for each event the emitter should listen to.
The Source property of the Event Handler Properties is one of the Events that exists in the current System.
An Event Handler can spawn new particles.
The Event Handler can operate either on all particles, a set of particles based on the particle's ID, or on particles spawned by the Event Handler.


(
I do not understand how to add new types of events, or even how to create new Modules that respond to existing events.
The `ReceiveLocationEvent` Module contains a `LocationEvent Read` node that I'm not able to create in my own script. It doesn't show up in the Node Graph context menu.
I can copy-paste the node from the Receive Location Event module to my module.
Cannot use that module though:
```
Missing definition string.

The Vector VM compile failed.  Errors:
/Engine/Generated/NiagaraEmitterInstance.ush(329): error: syntax error, unexpected '.', expecting ',' or ';'

 NE_Follow, Particle Event Script, 
```
This seems to be because I have two modules with the `ReceiveLocationEvent` node in the same Event Handler.
If I disable their `ReceiveLocationEvent` module and re-implement the parts of it that I need in my module that it works.
)

### Custom events

A custom event is generated from a module by adding an `Add <TYPE> Event Write` node, where `<TYPE>` is the type of the payload to send.
The module must be in the Particle Update module group, it seems.
Not sure, but events generated in Emitter Updates aren't picked up by the Source drop-down list in Event Handler Properties.


A custom event is received in a module by adding an `Add <TYPE> Event Read` node, where `<TYPE>` is the type of the payload to receive.
The module must be added to 


[How to Add Enums And Structs To Niagara @ niagara-vfx.herokuapp.com](https://niagara-vfx.herokuapp.com/how-to-add-enums-and-structs-to-niagara/#)

## Data interfaces

Used to send arbitrary external data into a particle system.
The data is made accessible in the Modules.
One example is the Houdini plugin, which can pre-simulate a rigid body simulation which is imported into Unreal Engine. With the simulation comes events for things such as body breakage, impact positions, body velocities, etc. These can be used as events in the particle system.


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

[Diving Into Niagara: Intelligent Particle Effects | Unreal Fest Online 2020 by Unreal Engine @ youtube.com](https://youtu.be/oX6uiPWXJDY?t=1654)  




[VFX and Particle Systems @ learn.unrealengine.com](https://learn.unrealengine.com/course/2547426/module/5502400)  
[Advanced Niagara Effects | Inside Unreal by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=31GXFW-MgQk)  
[Events and Event Handlers Overview @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Niagara/EventHandlerOverview/index.html)  
[Niagara by tharlevfx @ youtube.com](https://www.youtube.com/playlist?list=PLHjQE2fLIZu97z7Iwf-PjV2e1Y4_k2GKL)  