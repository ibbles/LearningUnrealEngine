2020-12-03_21:50:39

# Niagara parameters

Parameters let us provide customizations of an emitter or particle system.
Parameters are an abstraction of data.
Each parameter has a type, which is one of:
- `Primitive`: Numeric data of varying precision and channel widths.
- `Enum`: One of a fixed set of named values.
- `Struct`: A set of Primitives and Enums.
- `Data Interface`: Provided data from other parts of the application.

Parameters are created either explicitly through `Create New Parameter` or implicitly using a `Set Specific Parameter` module.

Namespaces provide containers for hierarchical data.
For example, the Emitter part of Emitter.Age show that this is the age of an emitter, while Particle.Position is the position of a particle.
Our parameter map is the particle payload that carries all of the particle’s attributes. As a result of this, everything becomes optional.

(
I don't understand the last sentence.
)

Any type of data can be added as a particle parameter, including structs, matrices,and flags.


`Create New Parameter` adds a `Set Variable` module to the stack.
There are four types of parameters: Primitive, Enum, Struct, and Data Interface.
A Collision Query is a struct.
Curl Noise is a Data Interface.
There is a long list of parameter types.

`Location` spawns particles in a grid.
The naming here is odd.

`MAX Scripts` has to do with vertex animation.
I don't think I need this.

`Set Specific Parameters` is very similar to `Create New Parameter`.
It also adds a `Set Variable` module to the stack.
There is a list of `Emitter.` and `System.` parameters that can be set.

`Spawning Modules` are Spawn Per Unit and Spawn Rate.
`Unit` in Spawn Per Unit is unit length, and is the distance the emitter has traveled.
`Rate` in `Spawn Rate` is particles per second.

(
How can modules added to the Particle Spawn group continuously spawn particles? They are only executed at the spawn event and will never again be given the opportunity to spawn particles.
)