2021-06-03_17:06:06

# Random

## Primitives

There are Blueprint Visual Script nodes for creating random values of various types.
These are all uniformly distributed.
- Random Bool. `{true, false}`
- Random Float. `[0..1)`
The documentation doesn't say if it's inclusive or exclusive, so I'm assuming it's 0-inclusive, 1-exclusive.
- Random Integer. `[0..Max-1]`
`Max` is a parameter.
- Random Integer 64. `[0..Max-1]`
`Max` is a parameter.
- Random Bool with Weight. `{true*Weight, fale*(1.0-Weight)}`
`Weight` controls how likely it is to get `true`. 0.0 means never, 1.0 means always, 0.5 mean 50/50 split between `true` and `false`.
- Random Float in Range. `[Min..Max)`
Again, not sure if `Max` is inclusive or exclusive
- Random Integer in Range. `[Min..Max]`
This one is inclusive at both sides.
- Rand Integer 64 in Range. `[Min..Max]`
This one is inclusive at both sides.


## Vectors

- Random Point In Bounding Box. `[Origing - Box Extent, Origing + Box Extent]`
- Random Unit Vector.
- Random Unit Vector In Cone In Degrees|Radians.
Cone defined by direction vector and half-angle.
- Random Unit Vector in Elliptical Cone in Degrees|Radians.
Elliptical cone defined by direction vector and two half-angles.


## Rotators

- Random Rotator. With or without roll.
Gives a random rotation with out much control.

The library for random rotators is pretty small.
Rotations are probably best made by randomizing Vectors and creating rotations from that.
We can use e.g one of the Random Unit Vector In Cone nodes to produce a new vector slightly offset from e.g. Get Actor Up Vector.
And then Find Look at Rotation to convert the difference between the Actor Up and the random vector to a Rotator.
We can also use Make Rot from Z or Make Rot from ZX by passing Get Actor Forward Vector to X and the random Vector to Z.
There is also Rotator From Axis Angle that could be used, using the random vector as the axis.