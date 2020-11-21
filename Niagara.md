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

(
There is some confusion about attributes and parameters here.
Sometimes parameter is used to refer to values stored "somewhere" and accessed within a module.
Sometimes parameter is used to refer to the subset of the attributes that a module accesses.
The later use of parameter is the same as parameters to a function. These are also called "input parameters".
The former use of parameter is the same as parametrization of a system.
)

A modules is like a function, something that takes some set of input data and produce some kind of output data.
Modules speak to common data, the affect particle positions and velocities and such.
Modules encapsulate behavior, for example to simulate attract force, or gravity, or noise.
Modules stack with each other to accomplish more complex behavior.
Modules are implemented using the graphs, the regular visual scripting language in Unreal Engine.

The module graph has four fundamental node types:
- `InputMap`: The incoming parameter map. A container with all the attributes and parameters in the system.
- `Map Get`: Used to read attributes and parameters from the input map.
- `Map Set`: Attributes and parameters set on the map is passed on to modules "down the stack".
- `Output Module`: 

The logic of the module is implemented as expression nodes between the `Map Get` nodes and the `Map Set` nodes.

Think of `Map Get` and `Map Set` as opening and closing a big box of stuff.

The `Map` nodes uses hierarchical names to address into the attributes and parameters.
Names such as `Particles.Velocity` and `Module.VelocitySCale`.
The `Particles` namespace contains the per-particle attributes.
Attributes in the `Module` namespace are user-defined.

Add a new module parameter by clicking the `+` in the `Map Get` node and type into the search box.
New attributes are added by clicking the `+` next to one of the attribute containers in the Parameters Panel.
After being created the attribute can be added to the `Map Get` node.

(
I'm not entirely sure on the difference between the `Map Get` `+` and the Parameters Panel `+`.
In the Houdini Niagara [video about custom attributes](https://www.sidefx.com/docs/unreal/_niagara.html#CustomModuleAttributes) at 7:50 the user tries to add Emitter Age from the Parameters Panel but it doesn't show up.
It does however show up from `Map Get`.
Why the difference?
)

The `Map Get` node can also be used to create input parameters.
Click the `+`, select Create New Parameter, and pick a type.
Input Parameters will be shown  under Module Inputs in the Parameters Panel.
Arguments are passed to the input parameters from the Emitter Editor by selecting the Module in the stack.
The value can either be:
- Set directly to a numeric value.
- Bound to an Emitter Parameter by dragging it from the Parameter Panel.
- Computed using an expression tree, created using expression statements accessed from the drop-down menu.

Attributes can have Namespace Modifiers, which is a kind of sub-group grouping.
The default NamespaceModifier for a newly created attribute is `Module`.
This name can be changed.

New output parameters are added by clicking the `+` on the `Map Set` node.
Implement logic by placing expression nodes between the `Map Get` output pins and the `Map Set` input pin.
There is a library of built-in nodes available to the Module Graph.
There is a HLSL node where code can be written in a text area.

Modules can control when they execute, in what contexts the module is valid.
For example on spawn, on tick/update.
This dictate which part of the stack the module may be placed.
This is set in Script Details > Script > Module Usage Bitmask.
Different placement in the stack may produce different behavior for a module.
Scaling velocity in spawn causes a single kick, scaling in update gives an acceleration.

A module can be included in the module search dialogs by checking Script Details > Script > Expose to Library.

The Module Graph, with all of its nodes, specifies a HLSL program.
The HLSL program is compiled either to a GPU shader or to CPU virtual machine instructions.


## Common attributes

`Particles.Velocity`

`Engine.DeltaTime`


## Emitters

Emitters are assets that live in the Content Browser.
Emitters are single-purpose, reusable components.
Emitters are building blocks for Systems.
We only set defaults on the Emitter. An emitter instance in a System can be tweaked.
Emitters are containers for modules.
They contain modules that provide the intended behavior of the particles.
The modules are stacked, so that one run after the other.
The module stacks are grouped into:
- Emitter Spawn: When the emitter is spawned.
- Emitter Update: Every update.
- Particle Spawn: When new particles are spawned.
- Particle Update: Every update.
- Event Handlers: When the source event is triggered.
- Render: Every frame.

Parameters on the modules bubble up and can be modified on the emitter.

The Emitter Editor consists of the following parts:
- Module Stack: A list of modules added to the emitter.
- Parameter Pane: Contains all the emitter, system, particle, and user attributes available.
- Sequencer timeline: Controls looping loop count, spawning, etc.
- Top Tool Bar: Just some buttons.

In the Top Tool Bar:
- Compile: Compiles the system so that we can see the result in the Preview Panel.
- Apply: Apply the latest changes to all Systems that use this Emitter.

### Module Stack

The Module Stack is color coded.
- Orange: Emitter modules. Spawn rate and such.
- Green: Particle modules. Run per particle.
- Red: Rendering.

There is also blue, which is only used in the System Editor, not the Emitter Editor.

The particle modules are split into two sections.
- Particle Spawn: Only run when a particle is being born.
- Particle Update: Run every tick/frame.

The module stack of a new emitter is mostly empty.
In particular, there is no particle spawn modules so no particles will be created.

Add a module to a section by clicking the `+` next to that section and type the module name.
May need to uncheck "Library Only" to see your own modules.
This is avoided by checking `Expose to Library` in the module settings.

There may be dependencies between modules.
The Emitter Editor will warn about unmet dependencies and provide help for fixing them.
Sometimes a button to do the fix for you. Sometimes the button works, sometimes it doesn't.

Individual modules can be enabled and disabled using the checkbox in the far right.

Modules have Input Parameters.
Input Parameters can be set in the following ways:
- Local Value: A value specified directly.
- Linked Input: The value is copied from somewhere else.
- Dynamic Input: The value is computed.

By default a Module in a Module Stack has each of its Input Parameters set to Local Value, which is the regular "type a value here" kind of widget.

Linked Input is what you get when you drag a compatible Parameter from the Parameters Panel to a Module's Input Parameter.

A Dynamic Input is an expression, implemented as a graph, that can be assigned to an Input Parameter.
They can be nested, so the input to a Dynamic Input can itself by a Dynamic Input.
Unreal Engine provide a library of Dynamic Inputs, for example to perform arithmetic or generate random numbers.
A Dynamic Input can be bound to a Curve.
A Curve is a function, defined with control points in a 2D widget, that is evaluated every update.
The function input can be Dynamic Input or bound to a parameter.
Curves can either be edited directly in the Module Stack or in the Curves Panel.

HLSL can be used to compute Input Parameter arguments.
Select Expression > Make new expression from the variable drop-down menu.
Can use any HLSL function.
Has access to any variable in the particle, emitter, and system namespaces.
Depending on the context of the expression, I guess.
Particle attributes are only available in a per-particle context.
Example:
```
Particle.NormalizedAge * 100 + Engine.Owner.Velocity
```


We can sample a vector field using the Sample Vector Field module.
Must also have an Apply Vector Field module.
The vector field can apply either a force or a velocity.


Particles can be rendered as sprites, lights, meshes, ribbons.
It is possible to have multiple renderers in the same stack, e.g. rendering particles with both sprites and meshes.
The rendering modules contains a section name Bindings.
This is where we tell the renderer where it should read data from.

Custom spawning modules can also be created.

### Spawning particles

Particles are spawned by adding a particle spawning module to the Emitter Spawn module group.
I would expect that they would be allowed to be put in Emitter Update as well, but I get warnings about Emitter Life Cycle and the `fix` button moves the spawn module from the Emitter Spawn group to the Emitter Update Group. Don't know why.

There are a few built-in spawning modules such as Spawn Burst Instantaneously and Spawn Rate.

My current understanding is that any `Module` Attribute of type Spawn Info written during Emitter Update will be picked up by the Emitter and particles spawned in response.

To create a custom particle spawning module:
- Create a new Niagara Module Script.
- In Script Details Panel > Script:
    - Module Usage Bitmask: Check only Emitter Spawn and Emitter Update.
        (Some of the build-in modules have Module checked as well. Don't know what that means.)
        (The Spawn Burst Instantaneous module have System Spawn checked. That makes no sense to me. This also generates a warning about EmitterLifeCycle and the Fix Issue button is unable to create the missing dependency. I think this is a miss-click by the module author.)
    - Required Dependencies: EmitterLifeCycle, Pre Dependency, All Scripts.
        (I don't know why the EmitterLifeCycle dependency is required.)
- In Parameters Panel > Emitter Attributes add a new Spawn Info. Can have any name.
- In the Node Graph create a Make Spawn Info Node.
- Wire up the input pins to whatever expression nodes suite your needs.
    - Count: The number of particles to spawn this update.
    - Interp Start Dt: Offset from the current frame begin time to start spawning.
    - Interval Dt: Defining the time gap between particles being spawned.
    - Spawn Group: Allows spawned particles to belong to different categories.
        (I don't understand what most of these do. Can spawning be scheduled to happen in the future?)
- Wire the Make Spawn Info output pin to a `Map Set` node that sets the `Spawn Info` attribute we created.


Instantaneous spawning.
It seems spawning must be done in Emitter Update, which means that the spawning module will run every update.
One way to prevent spawning until and after the appropriate update use an `if` to select between a filled `Make Spawn Info` and an all zero one.
The input to the `if` can be something along the lines of
```c
PreviousAge = Age - DeltaTime;
PreviousRemaining = SpawnTime - PreviousAge;
HaveNotSpawnedYet = PreviousRemaining >= 0;

Remaining = SpawnTime - Age;
ShouldHaveSpawned = Remaining < 0;

if (HaveNotSpawnedYet && ShouldHaveSpawned)
{
    MakeSpawnInfo(Count);
}
else
{
    MakeSpawnInfo(0);
}
```

SpawnBurstInstantaneous also sets the `Transient` attribute SpawningbCanEverSpawn to `true` as long as the spawn hasn't happened yet. After the spawn  has happened the module leaves the flag unchanged.

`SpawningbCanEverSpawn = SpawningbCanEverSpawn || (LoopedAge <= SpawnTime);`


Newly spawned particles can be positioned with modules such as Sphere Location or Box Location.
These pretty much just set the Position attribute of the newly spawned particles.
One tweak is that they don't position each particle within a global volume.
Instead the volume is centered around each particles.
This makes it possible to chain multiple location modules after one another, creating a sort of fuzzing effect.

[Emitter Spawn @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Niagara/EmitterReference/EmitterSpawn/index.html)  

### Parameters Pane

Contains all the parameters accessible by the selected emitter and its modules.
This includes parameters created from within a Module.
Will only show custom module parameters of modules are are actually in the emitter's module stack.

Parameters are grouped into namespaces.
- User Exposed: Parameters that can be modified from the outside, by a Blueprint for example.
- Engine: Parameters that exist outside of the particle system.
- System: Parameters related to the entire System, shared between all Emitters and particles in that system.
- Emitter: Parameters related to a particular Emitter, shared between all particles created by that Emitter.
- Particles: Per-particle parameters.

A parameter with the same name can exists in multiple namespaces.
They are separate parameters with separate values.
A parameter can also exist multiple times within the same namespace.
Each particles has their own unique age, position, and so on.

Each module has access to the parameters that corresponds to the module's group's namespace.
For example, modules in the Particle Spawn and Particle Update has access to the parameters within the Particles namespace and any namespace above.
Modules in the Emitter Update group has access to the parameters in the Emitter namespace and above.

A parameter can have a namespace modifier.
This can be used as a tag or a sub-namespace.

New parameters can be created using the `+` button next to each namespace.
Values cannot be set to parameters here.
Parameters can be dragged from the Parameters Panel to Module Input Parameter fields in the Module Stack.

Some important parameters:
- `Engine.Owner`: The emitter itself.

### Timeline Panel

Shows the current time in the simulation.
Normally hitting Space Bar will reset back to t=0.
While in the Timeline Panel Space Bar will instead toggle play/pause.

Interesting events, such as the time of a Spawn Burst Instantaneous module, is shown as a white diamond.

### Curves

Used to edit curves used as Dynamic Inputs to Module input parameters.
Several curves can be viewed at the same time.
Shift-click to add a new control point to a curve.
Select and hit Delete to remove.
Buttons on the Tool Bar control tangents.

### Scratch Pad Panel

Area where you can experiment with module scripts.
The scratch module can be injected into the Emitter Module Stack.
Can also be saved out to a Module assets for long-term use.

## System

Systems are assets that live in the Content Browser.
Systems are containers for multiple emitter.
A system produces one complete effect.
An example of an effect is a firework.
The emitters are choreographed using emitter sequencing in a timeline.
Can set which emitters loops and bursts and so on.
Systems have global variables that are available to the contained emitters.

The System Editor is very similar to the emitter editor.
There is one more Module Stack section, colored in blue, which contain the system level modules.
Here we add Modules that are global to the module.

New emitters are added using the `+ Track` button in the Timeline Panel.
Or through the System Overview context menu.
All emitters are listed as separate tracks in the Timeline Panel.
Here we control the relative timing between the emitters.

The added emitters can be modified to tweak the effect.
We can add and remove modules.
We can change parameter values on the modules.
The green arrow next to each module parameter reverts back to the parent emitter's value for that parameter.
The yellow arrow resets to the default for the type of the parameter, which is often 0 of some kind.
Click the top-right corner of the Emitter in the System Overview Panel to jump to the parent Emitter.

One can hide particles from an Emitter by unchecking the checkbox in the lop-left of the emitter or in the Timeline Panel.
The Isolate button, the standing man, on each Emitter hides the particles from all the other emitters.


System can inherit from each other.
Inherited modules can be disabled.
New modules can be added.
Module parameter input values can be changed, both setting a new value and create a new binding.

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


## Data interfaces

Used to send arbitrary external data into a particle system.
The data is made accessible in the Modules.
One example is the Houdini plugin, which can pre-simulate a rigid body simulation which is imported into Unreal Engine. With the simulation comes events for things such as body breakage, impact positions, body velocities, etc. These can be used as events in the particle system.


## GPU Particles

A particular Emitter is either spawning CPU or GPU particles.
This is selected in Tmitter Properties > Emitter > Sim Target.
Select CPUSim or GPUCompute Sim.

GPU particle systems should have a fixed bound.
This is because the CPU needs to know where the particles might be but that information is only on the GPU.
If there are particles outside of the bounds then those may be popping as the smaller bounds is transitioning in and out of view.
Set in the Emitter or System properties, and can be visualized with the Bounds button in the Emitter Tool Bar.
The Tool Bar button has a sub-button that sets the bound to the current particle space volume.


[VFX and Particle Systems @ learn.unrealengine.com](https://learn.unrealengine.com/course/2547426/module/5502400)  
[Advanced Niagara Effects | Inside Unreal by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=31GXFW-MgQk)  
[Events and Event Handlers Overview @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Niagara/EventHandlerOverview/index.html)  
[Niagara by tharlevfx @ youtube.com](https://www.youtube.com/playlist?list=PLHjQE2fLIZu97z7Iwf-PjV2e1Y4_k2GKL)  