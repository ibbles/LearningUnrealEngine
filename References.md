2020-08-10_20:56:10

# References

A reference is a link from one Blueprint to another.
Used when the Event Graph, or other Blueprint script, in one Blueprint should modify another Blueprint.
References are stored in a Variable (Blueprint class) or a `UPROPERTY` (C++ class).
References are often set by editing the property in the Details Panel of a Blueprint class instance.
Either pick from the drop-down menu or use the Actor picker for Actor references.
References can be None, meaning the reference doesn't reference anything.
References can be casted, i.e., the referenced object is seen as another type than the type of the reference.
The new type must be a child type of the original type.
For example to cast an Actor reference to a Player reference.
The cast will fail, i.e., return None, if the referenced object isn't of the casted-to type.
Always check for None after a cast.

Avoid circular dependencies.
Didn't quite understand this.
From Epic Games > Online Learning > Blueprints - Essential Concepts > Caveats Using Bluepint.
https://learn.unrealengine.com/course/2436619/module/5328682
He talks about dependencies, class loading order, and depending of half-loaded Blueprints.