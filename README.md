# Particle systems

## Niagara presentations

### Programmable VFX with Unreal Engine's Niagara | GDC 2018 | Unreal Engine

URL: https://www.youtube.com/watch?v=mNPYdfRVPtM  
By: Unreal Engine  
Published: Mar 22, 2018  
Duration: 56m 01s

Unreal much broader in scope now than before.
Moving into domains where Epic Games isn't the experts.
Goal is to give control to the artists.
Support for arbitrary data, from other parts of Unreal Engine or external.
Started with data sharing, expose everything.
Uses namespace paradigm, hierarchical containers.
`Emitter.` namespace, `Particle.` namespace.
Parameter map is the particle payload, the data we have asked to come along.
Read from and write to parameter map.
Makes everything optional, can disable stuff used for rendering when not rendering.
Can add arbitrary data to payload.
Uses both graphs and stacks.
Graphs are flexible, stacks are modular and give at-a-glance overview.
Hierarchy:
Modules speak to data, encapsulate behavior, and stack nicely.
Works like function.s
Emitters are containers for modules.
Emitters are single purpose reusable pieces of a larger particle system.
Parameteres can bubble up from modules to the emitter.
Systems hold emitteres.
Modules are graphs.
Emitters are collections of stacks.
Systems are timelines.

A module start with an Input Map.
This is our access point to the payload.
We get data from the map and do some work.
When we have a result we write it back to the parameter map.
Open, read, work, write, close.
Engine namespace: The thing that owns this particle system.
Module namespace: Things that I as a model author have added and exposed.
Particle namespace: Data that belong to the current particle.
Map Get Particles.Velocity and Module.VelocityScale → Multiply the two → Map Set Particles.Velocity.
Module Usage Bitmask dictate when a module may be used.
Since we read and write particle data, the example module can only be used in particle groups.
These are Particle Spawn, Particle Spawn Interpolated, Particle Update, and Particle Event.
Strive to build modules that stack nicely with each other.
Accumulate rather than set things such as forces.
Use temporary namespaces.
Temporary namespace are "unreserved" namespace names, just pick one.
Examples uses `Physics.`.
Multiple modules using the same name in a namespace will see each other's data.
Example uses `Physics.Force`.
_Not clear to me how the temporary data is stored/assigned/structured._
_Will it be one per particle? One per emitter?_
_Depends on the group the access is part of?_
_What if the same name in used in multiple places in the hierarchy?_
At the end of the frame the data will be thrown away.
Called transient values.
_Do we get a default value, e.g., zero, when a transient value is read first read?_
Everything compiled down to HLSL. Sent to GPU or CPU virtual machine.
Goal as full partity CPU and GPU. When applicable.
Can have raw HLSL in a node.

Screenshot of editor.
Stack to the right, color coded by behavior section.
Orange is emitter, stuff that happens at the emitter level instead of per-particle level.
Both spawn and update. First frame versus all subsequent frames.
Modules listed in the stacks are all optional, even very basic stuff such as age or velocity/position integration.
Green is particle.

The parameter pane list particle-emitter-system-user parameters.
Can just drag them into the stack.
Can be shared between multiple emitters.

The sequencer timeline controls looping, loop count, bursts, random start/stop, spawn rate.

Emitters are building blocks of system.
Systems have their own set of global user variables.
Systems control timing between emitters.
Systems have their own Spawn and Update stacks, in blue.
The system timeline show all emitters and renderes.
Systems have a render stack.
Simulation decoupled from rendering.
Simulate once, render in multple ways.

Module creation demo.
Default values for parameters can be provided in a module.
The attribute spreadsheet shows all the data in the system.

Inheritance important to design.
Old tools (Cascade) made reuse difficult.
Overrides can be inserted anywhere.
A system can uncheck a module from an imported emitter.
A system can insert new modules into an imported emitter.

Dynamic inputs.
Like modules, uses graph logic and user facing values.
Not working on parameter map, working on a type.
Ex: dynamic input with Vector. eg mirror it, uniform distribution,.
Can get data from somewhere outside of Niagara.

Micro expressions.
HLSL pretty much anywhere.
Can access particle attributes.
Good for small one-off features.

Demo of inheritance and modularity.

Events.
A way to communicate.
Can send any payload.
Struct of anything.
Can run events directly on a particle, all particles in a system, spawned particles.
`LocationEvent Write` struct in graph. Add the data you want.
Add event handles to the stack, tell it how to behave.
Events have a separate execution stack.
Demo of recursive three builder.
Demo of teslacoil.

Data interfaces.
Access to arbitrary data.
Can write plugin for greate extensibility (in the future?).
Example from Houdini simulation.
Built-in component is skeletal mesh data interface.






### Building Effects with Niagara and Blueprint | GDC 2019 | Unreal Engine

URL: https://www.youtube.com/watch?v=etSfYfIIoSE  
By: Unreal Engine  
Pusblished: Mar 25, 2019  
Duration: 29m 21s

Niagara consists of several pieces to make it easier to extend share resources between systems.
A Niagara system is something that is added into the world.
Niagara systems contains Niagara emitters.
An emitter can for example be fore sparks, smoke, and flames.

The Emitter GUI contains the viewport, the modules, and a timeline.
On the right, every block is called a module.
It's a series of instructions that get run at that point in the system.
`Emitter Spawn`: When the emitter is first created, do this stuff.
`Emitter Update`: On every tick.
Green blocks are per-particle instructions.
Niagara modules are blueprint scripts.
In scripts, everything works in namespaces.
Uses default values if the variable doesn't exist.
Can have dependencies between modules, i.e., `Gravity Force` and `Solve Forces and Velocity`.
Used to build bigger systems with several modules.
Various ways to spawn particles.
Sphere, cylinder, ...
Orthgraphic projection viewport can be used as a ruler by holding middle mouse button.
Niagara systems can be created from an emitter by right-clicking the emitter.
The position of the system can be copy/pasted from another object by right-click on Location.
We can add new data to the particle system by clickig `+` in `Particle Spawn` and selecting e.g., `Vector 2D`.
We can see the data for every particle in the `Window` → `Attribute Spreadsheet`.
Can set spawn position direction by adding a `Particles.position` setting to `Particle Spawn`.
Can write code directly by setting the value type to `Make new expression`.
Can add `Sample Texture` to `Particle Update.`
Set `UV` to be `Particle.UV` to get the per-particle random value.
Now each new particle "own" a texel in the texture, and in this case each texel is a 3D space coordinate.
By setting the position of the particle to the sampled texture data we can create shapes.
Texture sampling can only be done with GPUSim particles.

### Introduction to Niagara | Unreal Fest Europe 2019 | Unreal Engine

URL: https://www.youtube.com/watch?v=2CtBa3zEaYU  
By: Unreal Engine
Published: May 20, 2019  
Duration: 25m 39s

If you need some piece of data that is accessable to all particles, then create it in `Emitter Spawn`.
Kind of like `BeginPlay`.
If you need to update that data over time, then do that in `Emitter Update`.
Kind of like `EventTick`.
`Particle Spawn` happens at the start of every particle's lifetime.
Set initial state, position, velocity, size, etc.
The various color fields are "tabs", e.g. the red is the render tab.
The gray sets are called "modules".

Create an empty emitter.
Create a sprite renderer.
Create a `Spawn Rate`.
`Spawn Rate` depends on `EmitterLifeCycle`.





## Studying Directional Burst template

The main part of a particle system is one or more emitters.
Let's study the `Directional Burst` template emitter.
It is created by right-clickig in the `Content Browser`, expanding `FX` and selecting `Niagara Emitter`.
From the emitter creation dialog select the `Directional Burst` template.

Opening the emitter we see that it consists of three main parts: a timeline, a set of parameters, and a stack of modules.
The module stacks are what defines the behavior of the emitter.
It consists of three sections, each with it's separate color.
Orange is for the emitter itself, green is for the emitted particles, and red is for rendering. Each colored part contains a collection of groups, and each group contains a stack of modules.

The orange Emitter section conists of the `Emitter Spawn` group and the `Emitter Update` group.
The first is executed when the emitter is created and the second on every tick.
The `Emitter Spawn` group created by the `Directional Burst` template contains a single module named `Emitter Properties`.
This is where we can set various general properties of the emitter.
The `Emitter Update` group contains two modules: `Emitter Life Cycle` and `Spawn Burst Instantaneous`.
`Emitter Life Cycle` seems to be a set of general emitter properties much like the `Emitter Properties` under `Emitter Spawn`.
The `Spawn Burst Instantaneous` modules is half of what defines this emitter.
This is where we define the number of particles that should be spawend in each burst, with the `Spawn Count` parameter.
I don't understand why that number of particles isn't spawned every tick.
What defines when it's time to spawn again?

The second section is the green `Particle Spawn`.
It contains the modules that should execute for each spawned particle.
The first module is `Initialize Particle`.
This can be considered a particle constructor.
Here we can set things such as lifetime, mass, color, and sprite size.
Unfortunately, changing the sprite size has no effect on the size of the particles.
`Mesh Scale` doesn't seem to do anything either.
I don't know what's up with that.
OK I got it, the next module in the `Particle Spawn` group is `Calculate Size by Mass`.
I'm guessing this is overwriting the values I set in `Initialize Particle`.
The last module in the `Particle Spawn` group is `Add Velocity in Cone`.
It gives each particle a random velocity within a cone.
The oddity here is that even with the same minimum and maximum `Velocity Strength` and a very narrow `Cone Angle`, some particles fly much farther and others.
I don't know why.
OK I got it, it's the `Velocity Fallof Away From Cone Axis` checkbox.
Moving on to the `Particle Update` group we find a number of modules related to particle simulation.
`Update Age` reduces the lifetime or particles and kill too old particles.
`Gravity Force` adds a gravity force to each particle.
`Drag` adds a drag force to each particle.
`Scale Color` scales the alpha channel of the particles so they fade out over their lifetime.
This doesn't seem to do anything. The particles disappears suddenly at the end of life no matter what alpha curve I set.
Isn't alpha supported by the renderer?
I switched, under `Rendering`, the `Material` from `DefaultSpriteMaterial` to `DefaultSpriteMaterial` and now the alpha curve works again.
`Solve Forces and Velocity` uses the forces we've added to compute new positions and velocities.
`Sprite Size Scale by Velocity` makes fast particles larger, I think.

The last section is the red one, which consists of the single `Render` group.
This one has a lot of parameters and toggles.

Having finished reading through the burst template, I was never able to figure out why `Spawn Count` particles wasn't spawned every tick by the `Spawn Burst Instantaneous` module in `Emitter Update`.
Invastigating another emitter template, a more continious one, to see what that emitter does differently.
Creating a particle system from a `Fountain` emitter.


## Comparing Direction Burst and Fountain

They both have the same `Emitter Spawn` → `Emitter Properties`.
Under `Emitter Update` → `Emitter Life Cycle`, the fountain has 0 `MaxLoopCount` and 5.0 `NextLoopDuration`, compared to the directional burst's `MaxLoopCount` of 10 and `NextLoopDuration` of 1.44....

Instead of `Spawn Instantaneous`, the fountain has a `Spawn Rate`.
This seems like an important difference.


## Creating a particle system from scratch

The goal is to create a particle emitter maintains a fixed number of particles.
We do this by having a target number of particles parameters and every now and then checking the current number of particles and if too low create create a bunch of new ones.

Right-click in the `Content Browser`, select `FX` → `Niagara Emitter`.
The created emitter has all the sections, orange, green, and red, and all the groups within the sections.
The only pre-created module is `Emitter Properties`, which is identical to the burst template.

Right-click in the `Content Browser` again and select `FX` → `Niagara Module Script`.
Name it `SpawnSomeParticles`.


## Particle system exercise ideas

### Tornado from scratch

A swirl of particles affected by a circular inward-facing force field.
Create using a blank/empty system/emitter and using no pre-existing modules.


### Keep max number

Continuation of the tornado.
Every now and then, spawn a bunch of particles so that a target number of particles exist.
Remove particles that move too far away from the tornado center.

Requirements:

- Burst spawning.
- Integer parameter.
- Current number of particles.


### Blueprint triggering

Trigger an emitter cycle on an existing partile system from a blueprint/C++.


### Flow over mesh

Spawn particles that flow over the surface of a mesh.
Remove particles that fall off the mesh.

Requirements:

- Collision Query struct parameter.
- Age tracking that is reset on contact.


### C++ simulation

Do particle simulation in C++, pass particle data to Niagara through a data interface.


### SPH

Requirements: Neighbor lists.


### CPU communication

Compute per-particle data in C++, access that data in a module.
