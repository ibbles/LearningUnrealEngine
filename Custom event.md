2020-05-10_18:32:07

# Custom event

A Event is like a function, but can be run asynchronously.
It might not run immediately, but at some later time, after the current graph has concluded or yielded.

## Blueprints

A Custom Event is an Event that we create ourselves.
We can add custom events  to an `Actor`'s Event Graph by right-click → Add Custom Event… .
Custom events can have inputs.

References to Custom Events can be created with the Create Event node.
Select the event to create a reference to from the Create Event drop-down menu.

## C++

Create an Event with a default/fallback C++ implementation with the Blueprint Native Event / `MyFunction_Implementation` pattern.

Create an event with `BlueprintImplementableEvent` if you want to implement the event in Visual Script but still be able to call it from C++.


[[2020-03-10_21:29:17]] [Actor](./Actor.md)  