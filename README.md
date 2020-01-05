# Learning Unreal Engine

This is a bunch of notes and code snippets that I write while figuring out how to use the Unreal Engine.

# Materials

A `Material`, or a set of materials, is what defines the colors an object has.
A `Material` is a blueprint and all `Materials` have a `Result Node` that define the properties of the material.


# AI units

In this section we create a AI controlled unit that moves around.
It is based on the following tutorial:

Unreal Engine Beginner Tutorial: Building Your First Game  
https://www.youtube.com/watch?v=QJpfLkEsoek  
Creates evil cubes.

The first step is to create the AI, the brain of the 

Create a new Blueprint class with `AIController` as parent named `UnitAI`.
In the event graph, add an `AI MoveTo`.
Drag from the `Pawn` pin and select `Get Controller Pawn`.
This find find the pawn that this AI is attached to.
Create a `Set Timer by FunctionName` to have the `AI MoveTo` trigger every now and then.
Give it the function name `MoveToCorner`, set time to 1.0, and enable looping.
Right-click and create a custom event with the same name, i.e., `MoveToCorner`.
Drag from `Event BeginPlay` to the timer to start the timer loop.
Connect `MoveToCorner` to `AI MoveTo`.
Now the `AI MoveTo` will be called once every second.

The second step is to create the unit that the AI is controlling.
Create a new blueprint class with `Pawn` as the parent.
Add static meshes of whatever else you want for a visual representation.
Also add a `Floating Pawn Movement`.
This is where we define how the unit is allowed to move.
Speed and acceleration and the like.
Select the root object, i.e. the `Pawn`, in the `Components` tab and look at the `Pawn` section of the details tab.
Find `AI Controller Class` and set it to the `UnitAI` class we created previously.

The third step is to create a navigation mesh.
In the `Place` mode, under `Volumes`, find `Nav Mesh Bounds`.
Scale it to cover the entive level.
In the viewport, click `Show` in the top-left and then click Nativation.
Walkable areas will be colored green.
There must be a mesh to walk on, so make sure you have a floor.
Not sure how to do a flying unit.


# Particle systems

On Unreal Engine 2.23 the `Niagara` plugin must be enabled to use particle systems.
Particel systems are created from the `FX` section of the `Content Browser's` right-click menu.

## Unreal Engine official documentation

URL: https://docs.unrealengine.com/en-US/Engine/Niagara/index.html  

Niagara is the part of Unreal Engine that deals with creating and previewing particle effects.
Before Niagara there were another particle system called Cascade.

### Niagara Overview

URL: https://docs.unrealengine.com/en-US/Engine/Niagara/Overview/index.html

There are four core components in Niagara:

- Systems
- Emitters
- Modules
- Parameters

A `System` holds emitters that together produce an effect.
There is a system editor in which emitters are added and configured.
It contains a timeline and a section that is very similar to the emitter editor.
`Emitters` produce and simulate particles.
Their behavior is controlled using modules and there is a stack of modules for each phase of the emitter.
Examples of phases are particle spawn, particle update, and render.
Theses phases are called groups, as they are a group of modules.
`Modules` are building blocks for behaviors, acting like regular functions.
Modules transforms the state of the particle system in some way, reading and/or writing common data.
Modules are stacked together to form a sequence.
They are created using blueprint graph nodes.
Unreal Engine ships with a sizable collection of useful modules.
`Parameters` let us provide customizations of an emitter or particle system.
A parameter can be either a primitive, and enum, a struct, or a data interface.
The first three are what they sound like.
The last one, data interface, is used to provide data from other parts of the application.
Parameters are created either explicitly through `Create New Parameter` or implicitly using a `Set Specific Parameter` module.

Each active module is a system belong to a group, and all modules in that group form a stack.
The modules in the stack are executed top to bottom when that group is triggered.
The group order is from large to small, starting with System groups, then Emitter groups, and finally Particle groups.
The groups are System Spawn, System Update, Emitter Spawn, Emitter Update, Particle Spawn, Particle Update, Render.

Modules in the Emitter Spawn group will execute when the emitter spawns.
Modules in the Emitter Update group will execute over time.
Modules in the Particle Spawn group will execute each time a particle is created.
Modules in the Particle Update group will execute per particle over time.
Event handlers allow particles to interact with each other and other emitters or systems.

Events are a way to communicate between elements (such as particles, emitters, and systems).
Events can be any kind of data, packed into a payload (such as a struct) and sent. Then anything else can listen for that event and take action.
An event can be run directly on a particle using Particle.ID, on every particle in a system, or spawn a collection of particles on run on those.

Data interfaces is an extensible system to allow access to arbitrary data, including meshes, audio, DDC information, code objects and text containers.

When creating a new system or emitter you are given the choise to create from a template.
Nothing is locked or special in such a system or emitter.

A module's function flow consists of four main parts: Reading from the incoming parameter map, performing computation or other actions, write restults into the parameter map, and finally module output.
Modules accumulate to a temporary namespace.
If two modules contrinbute to the same attribute the modules will stack and accumulate properly.

_I don't understand the above._

Modules created using the blueprint graph scripting language can be run on both the CPU and the GPU.

Dynamic inputs act on a value type instead of a parameter map.

_I don't understand what a dynamic input is._



### Key concepts

URL: https://docs.unrealengine.com/en-US/Engine/Niagara/NiagaraKeyConcepts/index.html  

Epic Games' goals when designing Niagara:

- Full control in the hands of the artist.
- Programmable and customizable on every axis.
- Tooling for debugging, visualization, and performance.
- Can incorporate data from other parts of the engine.
- Unobtrusive.

Namespaces provide containers for hierarchical data.
For example, the Emitter part of Emitter.Age show that this is the age of an emitter, while Particle.Position is the position of a particle.
Our parameter map is the particle payload that carries all of the particle’s attributes. As a result of this, everything becomes optional.

_I don't understand the last sentence._

Any type of data can be added as a particle parameter, including structs, matrices,and flags.

Modules speak to common data, encapsulate behaviors, and stack together.
The operations performed by a module are defined using a visual node graph.

Emitter are containers for modules that are stacked on each other.
Parameters on modules bubble up to become parameters on the emitter unless set by the emitter itself.

Systems are containers for emitters, which it combines to create an effect.
Emitter parameters are set by the system they belong to or become parameters of the system.
The module stacks of the emitters can be modified by the system.

Modules are assigned to groups.
Each group has a defined point in time when it's modules are executed.
Modules are executed top to bottom.
Modules part of the System group is executed first, handling behavior that is shared with every emitter.
Then the modules of the Emitter groups are executed, once for each emitter.
Then the modules of the Particle groups are executed, once for each particle.
Then the modules of the Render groups are executed.

In addition to when a module is executed, the group assignment also control what data the module operates on.
Each collection of data is called a namespace.
Modules in the group that correspond to a namespace can read/write parameters in that namespace, and read parameters in the namespaces above it.
The namespace order is Engine, User, System, Emitter, Particle.
Computation whose results are used in several instances of a lower lever should be computed in an upper level.


| Group       | Read | Write |
|-------------|------|-------|
| System      | Engine, User, System | System |
| Emitter     | Engine, User, System, Emitter | Emitter |
| Particle    | Engine, User, System, Emitter, Particle | Particle |


Rotated the other way we get the following table.


| Group    | Engine | User | System | Emitter | Particle |
|----------|--------|------|--------|---------|----------|
| System   | 👀     | 👀   | 👀🖊   |         |          |
| Emitter  | 👀     | 👀   | 👀     | 👀🖊    |          |
| Particle | 👀     | 👀   | 👀     | 👀      | 👀🖊     |




### How-to index (this should perhaps not be it's own section)

URL: https://docs.unrealengine.com/en-US/Engine/Niagara/HowTo/index.html


### Emitter reference (this should perhaps not be its own section)

URL: https://docs.unrealengine.com/en-US/Engine/Niagara/EmitterReference/index.html  




## Niagara presentations

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

Every now and then, spawn a bunch of particles so that a target number of particles exist.
Kill particles that fall off the edge of a box.
An alternative to the box, use the tornado described above and delete particles that move too far away from the tornado center.

Requirements:

- Burst spawning.
- Integer parameter.
- Current number of particles.


### Blueprint triggering

Trigger an emitter cycle on an existing partile system from a blueprint/C++.


### C++ simulation

Do particle simulation in C++, pass particle data to Niagara through a data interface.


### SPH

Requirements: Neighbor lists.


### CPU communication

Compute per-particle data in C++, access that data in a module.
