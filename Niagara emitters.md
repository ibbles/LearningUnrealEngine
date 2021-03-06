2020-12-03_21:34:16

# Niagara emitters

Emitters are assets that live in the Content Browser.
Emitters are single-purpose, reusable components.
Emitters are building blocks for Systems.
Systems are containers for emitters, which it combines to create an effect.
We only set defaults on the Emitter. An emitter instance in a System can be tweaked.
Systems have their own set of global user variables.
Emitter parameters are set by the system they belong to or become parameters of the system.
Emitters are containers for modules.
Emitter are containers for modules that are stacked on each other.
They contain modules that provide the intended behavior of the particles.
Modules listed in the stacks are all optional, even very basic stuff such as age or velocity/position integration.
Parameters on modules bubble up to become parameters on the emitter unless set by the emitter itself.
The modules are stacked, so that one run after the other.
Theses phases are called groups, as they are a group of modules.
The module stacks are grouped into:
- Emitter Spawn: When the emitter is spawned.
- Emitter Update: Every update.
- Particle Spawn: When new particles are spawned.
- Particle Update: Every update.
- Event Handlers: When the source event is triggered.
- Render: Every frame.

Spawn vs Update. First frame versus all subsequent frames.
(
_No Update on first frame?
)

Parameters on the modules bubble up and can be modified on the emitter.
The module stacks of the emitters can be modified by the system.

The Emitter Editor consists of the following parts:
- Module Stack: A list of modules added to the emitter.
- Parameter Pane: Contains all the emitter, system, particle, and user attributes available.
- Sequencer timeline: Controls looping loop count, spawning, etc.
- Top Tool Bar: Just some buttons.

The parameter pane list particle-emitter-system-user parameters.
Can just drag them into the stack.
Can be shared between multiple emitters.

The sequencer timeline controls looping, loop count, bursts, random start/stop, spawn rate.

In the Top Tool Bar:
- Compile: Compiles the system so that we can see the result in the Preview Panel.
- Apply: Apply the latest changes to all Systems that use this Emitter.

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


## Emitter spawn

The `Emitter Spawn` group is executed once when the emitter is created.
The following types of modules can be included:

- Create New Parameter
- Location
- MAX Scripts
- Set Specific Parameters
- Spawning
- Vector Field
- User-created custom modules.


## Emitter update

The `Emitter Update` group is executed on every tick.
It is used to compute values for particle spawn or to update emitter parameters.
The following modules intended for `Emitter Update` are included in Unreal Engine.

- Beam
- Create New Parameter
- Emitter
- Location
- MAX Scripts
- Scalability
- Set Specific Parameters
- Spawning
- Utility
- Vector Field

Use-created custom modules can also be added.

The `Beam` module provide settings for beam emitters.
`Create New Parameter` works the same in Emitter Update as it does in Emitter Spawn.
The `Emitter Lice Cycle` module control how the emitter loops.
There are four `Spawning` modules:

- Spawn Burst Instantaneous
- Spawn Per Frame
- Spawn Per Unit
- Spawn Rate

## Module Stack

Every emitter is created with an \`Emitter Properties\` item in its stack.
It contains a bunch of properties that is configured for this emitter.

The group order is from large to small, starting with System groups, then Emitter groups, and finally Particle groups.

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

## Spawning particles

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

## Parameters Pane

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

The number next to each attribute in the Parameters Panel is the number of modules that uses that attribute.

Some important parameters:
- `Engine.Owner`: The emitter itself.

## Timeline Panel

Shows the current time in the simulation.
Normally hitting Space Bar will reset back to t=0.
While in the Timeline Panel Space Bar will instead toggle play/pause.

Interesting events, such as the time of a Spawn Burst Instantaneous module, is shown as a white diamond.

## Curves

Used to edit curves used as Dynamic Inputs to Module input parameters.
Several curves can be viewed at the same time.
Shift-click to add a new control point to a curve.
Select and hit Delete to remove.
Buttons on the Tool Bar control tangents.

## Scratch Pad Panel

Area where you can experiment with module scripts.
The scratch module can be injected into the Emitter Module Stack.
Can also be saved out to a Module assets for long-term use.




URL: https://docs.unrealengine.com/en-US/Engine/Niagara/EmitterReference/EmitterSettings/index.html  
URL: https://docs.unrealengine.com/en-US/Engine/Niagara/EmitterReference/EmitterSpawn/index.html  
URL: https://docs.unrealengine.com/en-US/Engine/Niagara/EmitterReference/EmitterUpdate/index.html  
URL: https://docs.unrealengine.com/en-US/Engine/Niagara/EmitterReference/index.html  
