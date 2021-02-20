2020-12-03_21:41:31

# Niagara modules

(
There is some confusion about attributes and parameters here.
Sometimes parameter is used to refer to values stored "somewhere" and accessed within a module.
Sometimes parameter is used to refer to the subset of the attributes that a module accesses.
The later use of parameter is the same as parameters to a function. These are also called "input parameters".
The former use of parameter is the same as parametrization of a system.
)

Modules are building blocks for behaviors, acting like regular functions.
A module is like a function, something that takes some set of input data and produce some kind of output data.
Modules transforms the state of the particle system in some way, reading and/or writing common data.
Modules speak to a shared pool data, the particle positions and velocities and such.
Modules encapsulate behavior, for example to simulate attraction forces, or gravity, or noise.
Modules are stacked together to form a sequence.
Modules stack with each other to accomplish more complex behavior, the result of one module being used by the next.
Modules speak to common data, encapsulate behaviors, and stack together.
Each active module is a system belong to a group, and all modules in that group form a stack.
The modules in the stack are executed top to bottom when that group is triggered.
The groups are System Spawn, System Update, Emitter Spawn, Emitter Update, Particle Spawn, Particle Update, Render.
Modules in the Emitter Spawn group will execute when the emitter spawns.
Modules in the Emitter Update group will execute over time.
Modules in the Particle Spawn group will execute each time a particle is created.
Modules in the Particle Update group will execute per particle over time.
Event handlers allow particles to interact with each other and other emitters or systems.

Modules are assigned to groups.
Each group has a defined point in time when it's modules are executed.
Modules are executed top to bottom.
Modules part of the System group is executed first, handling behavior that is shared with every emitter.
Then the modules of the Emitter groups are executed, once for each emitter.
Then the modules of the Particle groups are executed, once for each particle.
Then the modules of the Render groups are executed.

Module Usage Bitmask dictate when a module may be used.
Particle groups: Particle Spawn, Particle Spawn Interpolated, Particle Update, and Particle Event.

A module start with an Input Map.
This is our access point to the payload.
We get data from the map and do some work.
When we have a result we write it back to the parameter map.
Open, read, work, write, close.
Engine namespace: The thing that owns this particle system.
Module namespace: Things that I as a model author have added and exposed.
Particle namespace: Data that belong to the current particle.
Map Get Particles.Velocity and Module.VelocityScale → Multiply the two → Map Set Particles.Velocity.

Default values for parameters can be provided in a module.

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

If you need some piece of data that is accessible to all particles, then create it in `Emitter Spawn`.
Kind of like `BeginPlay`.
If you need to update that data over time, then do that in `Emitter Update`.
Kind of like `EventTick`.
`Particle Spawn` happens at the start of every particle's lifetime.
Set initial state, position, velocity, size, etc.
The various color fields are "tabs", e.g. the red is the render tab.
The gray sets are called "modules".

Modules are created using blueprint graph nodes.
The operations performed by a module are defined using a visual node graph.
Modules are implemented using the graphs, the regular visual scripting language in Unreal Engine.
The modules are implemented as node graphs which are compiled to HLSL.
Unreal Engine ships with a sizable collection of useful modules.

A module's function flow consists of four main parts:
- Reading from the incoming parameter map
- Performing computation or other actions
- Write results into the parameter map
- Module output.

Modules accumulate to a temporary namespace.
If two modules contribute to the same attribute the modules will stack and accumulate properly.
(
I don't understand the above.
)

Modules created using the blueprint graph scripting language can be run on both the CPU and the GPU.

Dynamic inputs act on a value type instead of a parameter map.
(
_I don't understand the above._
)
Dynamic inputs.
A way to build expressions directly in the binding for a parameter.
Think of them like expressions that can be composed together.
The result is assigned to a parameter.
Like modules, uses graph logic and user facing values.
Not working on parameter map, working on a type.
Ex: dynamic input with Vector. eg mirror it, uniform distribution,.
Can get data from somewhere outside of Niagara.

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
Attributes in the `Module` namespace are user-defined and local to the module.

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

Static Switch Inputs are compile-time Booleans.
They seem able to pair up with a regular module parameter when named `Use <PARAMETER>`.
This shows up as a check box next to the parameter name in the Selction Panel of the Emitter of Particle System editor when the module is selected in the module stack.

Attributes can have Namespace Modifiers, which is a kind of sub-group grouping.
The default Namespace Modifier for a newly created attribute is `Module`.
It is changed by right-click in a `Map Get` node > Change Namespace Modifier.
The `INITIAL` Namespace Modifier gives us a starting variable for this particular type.
`INITIAL` variables are often set by modules in the Particle Spawn module group.
The `MODULE` namespace makes the variable unique, meaning that we can create multiple instances of the module within the same module stack group and each module will have its own copy of the variable.
Each such variable will be given a Namespace Modifier that is the module instance's name.
We can also add custom Namespace Modifiers, which we can name whatever we want.
They have no build-in semantics within the engine.
`LOCAL` parameters cannot have a Namespace Modifier.

New output parameters are added by clicking the `+` on the `Map Set` node.
Implement logic by placing expression nodes between the `Map Get` output pins and the `Map Set` input pin.
There is a library of built-in nodes available to the Module Graph.
There is a HLSL node where code can be written in a text area.
Used for micro expressions.
HLSL pretty much anywhere.
Can access particle attributes.
Good for small one-off features.

To use custom particle attributes one must use the Parameters Panel of the module.
Click the `+` next Particle Attributes, pick a type, and enter a name.
When the module is added to an emitter then the new particle attribute is added to the Parameters Panel.

Parameters marked `LOCAL` only exist within the current execution of the current module.
This is used to break up the computation into stages and squirrel away temporary results in the parameters map.
The values can be retrieved later in the visual script from the parameters map.

Parameters marked `OUTPUT` survives the termination of the current module execution and can be accessed by later modules in the emitter module stack group.
They are not listed in the Parameters Panel.

Parameters marked `TRANSIENT` are like `OUTPUT`, but the value is lost at the end of the emitter module stack group execution.
(
_I'm not sure if this is also true for `OUTUT`, and if so, what's the difference between `TRANSIENT` and `OUTPUT`?_
)

Modules can control when they execute, in what contexts the module is valid.
For example on spawn, on tick/update.
This dictate which part of the stack the module may be placed.
This is set in Script Details > Script > Module Usage Bitmask.
Different placement in the stack may produce different behavior for a module.
Scaling velocity in spawn causes a single kick, scaling in update gives an acceleration.

Strive to build modules that stack nicely with each other.
Accumulate rather than set things such as forces.
Use temporary namespaces.
Temporary namespace are "unreserved" namespace names, just pick one.
Multiple modules using the same name in a namespace will see each other's data.
Example uses `Physics.Force`.
At the end of the frame the data will be thrown away.
Called transient values.
(
_Do we get a default value, e.g., zero, when a transient value is read first read?_
_Not clear to me how the temporary data is stored/assigned/structured._
_Will it be one per particle? One per emitter?_
_Depends on the group the access is part of?_
_What if the same name in used in multiple places in the hierarchy?_
)

A module can be included in the module search dialogs by checking Script Details > Script > Expose to Library.

The Module Graph, with all of its nodes, specifies a HLSL program.
The HLSL program is compiled either to a GPU shader or to CPU virtual machine instructions.
Goal is full parity CPU and GPU. When applicable.
Can have raw HLSL in a node.


`Vector Field Modules` is a bunch of different types of vector fields.
I don't know what they are for.


[Programmable VFX with Unreal Engine's Niagara | GDC 2018 | Unreal Engine by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=mNPYdfRVPtM)  
