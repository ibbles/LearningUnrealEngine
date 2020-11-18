2020-11-18_17:39:27

# Niagara

## Reason for new system

Cascade showing it's age. Inflexible. New effects and behaviors require programming.
Not suitable for a wide range of domains.
Need a new tool that puts more control in the hands of artists.
More flexibility in what kind of data and data sources can be used to drive the simulation.
Improved tools for debugging and visualization.

## Basic concepts

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

The `Map Get` node can also be used to create input parameters.
Click the `+`, select Create New Parameter, and pick a type.
Input Parameters will be shown  under Module Inputs in the Parameters Panel.
Arguments are passed to the input parameters from the Emitter Editor by selecting the Module in the stack.
The value can either be:
- Set directly to a numeric value.
- Bound to an Emitter Parameter by dragging it from the Parameter Panel.
- Computed using an expression tree, created using expression statements accessed from the drop-down menu.

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

The Module Graph, with all of its nodes, specifies a HLSL program.
The HLSL program is compiled either to a GPU shader or to CPU virtual machine instructions.


## Common attributes

`Particles.Velocity`

`Engine.DeltaTime`


## Emitters

Emitters are containers for modules.
They contain modules that provide the intended behavior of the particles.
The modules are stacked, so that one run after the other.
Emitters are single-purpose, reusable components.
Emitters are building blocks for Systems.

Parameters on the modules bubble up and can be modified on the emitter.

The Emitter Editor consists of the following parts:
- Module Stack: A list of modules added to the emitter.
- Parameter Pane: Contains all the emitter, system, particle, and user attributes available.
- Sequencer timeline: Controls looping loop count, spawning, etc.

### Module Stack

The Module Stack is color coded.
- Orange: Emitter modules. Spawn rate and such.
- Green: Particle modules. Run per particle.
- Red: Rendering.

The particle modules are split into two sections.
- Particle Spawn: Only run when a particle is being born.
- Particle Update: Run every tick/frame.

Add a module to a section by clicking the `+` next to that section and type the module name.
May need to uncheck "Library Only" to see your own modules.
There may be dependencies between modules.
The Emitter Editor will warn about unmet dependencies and provide help for fixing them.

Particles can be rendered as sprites, lights, meshes, ribbons.
It is possible to have multiple renderers in the same stack, e.g. rendering particles with both sprites and meshes.
The rendering modules contains a section name Bindings.
This is where we tell the renderer where it should read data from.

A Dynamic Input is an expression, implemented as a graph, that can be assigned to an Input Parameter.
They can be nested, so the input to a Dynamic Input can itself by a Dynamic Input.
Unreal Engine provide a library of Dynamic Inputs, for example to perform arithmetic or generate random numbers.

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

### Parameter Pane

Contains all the parameters accessible by the selected emitter and its modules.
This includes parameters created from within a Module.
Will only show custom module parameters of modules are are actually in the emitter's module stack.
New parameters can be created using the `+` button next to each namespace.
Values cannot be set to parameters here.
Parameters can be dragged from the Parameters Panel to Module Input Parameter fields in the Module Stack.

Some important parameters:
- `Engine.Owner`: The emitter itself.

### Sequencer timeline


# System

Systems are containers for multiple emitter.
A system produces one complete effect.
The emitters are choreographed using emitter sequencing in a timeline.
Can set which emitters loops and bursts and so on.
Systems have global variables that are available to the contained emitters.

The System Editor is very similar to the emitter editor.
There is one more Module Stack section, colored in blue, which contain the system level modules.
Here we add Modules that are global to the module.

New emitters are added using the `+ Track` button in the Timeline Panel.
All emitters are listed as separate tracks in the Timeline Panel.
Here we control the relative timing between the emitters.

System can inherit from each other.
Inherited modules can be disabled.
New modules can be added.
Module parameter input values can be changed, both setting a new value and create a new binding.


# Events



[VFX and Particle Systems @ learn.unrealengine.com](https://learn.unrealengine.com/course/2547426/module/5502400)  

