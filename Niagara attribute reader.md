2020-11-23_17:16:01

# Niagara attribute reader

An attribute reader is a Niagara Module node that read attributes from another emitter.
Can also read from itself.
The data will be one frame behind. (I think)

It consists of two parts.
First a module input parameter to the module that should do the reading.
Second a particle system reference that is set on an instance of the module in an Emitter Stack.

In the module that will do the reading, create a new Particle Attribute Reader input in the `Map Get` node.
On the Particle Attribute Reader call one of the `Get <TYPE> by <KEY>` functions.
`<TYP>` is a type such as Bool, or Color, or Float, or Vector.
`<KEY>` is either `ID` or `Index`.
The node that is created has either a Index or an ID input and two outputs: Valid, and Value.
Valid is true if the ID or Index corresponded to a value.
Value is the value of that attribute.
The node also has a text field for the name of the attribute that should be read.

On the module instance in the Emitter Stack there is a property named `Emitter Name`.
Set this to the name of the emitter that attributes should be read from.
This if often only possible to set in a System, since the Emitter won't know what other Emitters will be added.

The Get Num Particles function of Particle Attribute Reader is often useful.
