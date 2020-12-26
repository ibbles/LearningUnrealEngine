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

_I don't understand the last sentence._

Any type of data can be added as a particle parameter, including structs, matrices,and flags.
