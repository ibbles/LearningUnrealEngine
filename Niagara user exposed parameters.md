2020-11-26_20:34:56

# Niagara user exposed parameters

A user exposed parameter is created in a Niagara Emitter or a Niagara System.
It is a value that can be set from outside the particle system.
Either from Blueprint or from C++
The value is read-only to the Niagara modules.

User exposed parameters are created in Niagara Emitter Editor > Parameters Panel > User Expsed > Click `+`.
Select a data type for the value.
(Double?) Click the variable to give it a name.

The value is set from a Blueprint with the `NAME HERE!` node.
The name of the parameter to set must include the `User.` prefix.