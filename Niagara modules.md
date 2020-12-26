2020-12-03_21:41:31

# Niagara modules

(
There is some confusion about attributes and parameters here.
Sometimes parameter is used to refer to values stored "somewhere" and accessed within a module.
Sometimes parameter is used to refer to the subset of the attributes that a module accesses.
The later use of parameter is the same as parameters to a function. These are also called "input parameters".
The former use of parameter is the same as parametrization of a system.
)

A module is like a function, something that takes some set of input data and produce some kind of output data.
Modules speak to a shared pool data, the particle positions and velocities and such.
Modules encapsulate behavior, for example to simulate attraction forces, or gravity, or noise.
Modules stack with each other to accomplish more complex behavior, the result of one module being used by the next.
Modules are implemented using the graphs, the regular visual scripting language in Unreal Engine.
The modules are implemented as node graphs which are compiled to HLSL.

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
I'm not sure if this is also true for `OUTUT`, and if so, what's the difference between `TRANSIENT` and `OUTPUT`?
)

Modules can control when they execute, in what contexts the module is valid.
For example on spawn, on tick/update.
This dictate which part of the stack the module may be placed.
This is set in Script Details > Script > Module Usage Bitmask.
Different placement in the stack may produce different behavior for a module.
Scaling velocity in spawn causes a single kick, scaling in update gives an acceleration.

A module can be included in the module search dialogs by checking Script Details > Script > Expose to Library.

The Module Graph, with all of its nodes, specifies a HLSL program.
The HLSL program is compiled either to a GPU shader or to CPU virtual machine instructions.