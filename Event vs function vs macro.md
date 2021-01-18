2020-07-04_20:32:29

# Event vs function vs macro

Functions and macros can have return values, events can not.
Functions can have local variables, events can not. Unsure of macros.
Events can use Delay and Timeline nodes, functions can not.
Events can be replicated between machines, functions can not.
Event graphs can have multiple entry points and merging flow.
Events can have functions/other events bound to them. (Check this. What does it even mean?)
Both functions and events can be called from C++ code.
a BlueprintNativeEvent in a class is turned into either a function or an event depending on if it has a return value or not.

Functions represent an abstraction of a side effect or computation. It is executed immediately within the bounds of the calling graph/script. The calling script will not continue until the function has completed. Function calls are blocking.

An event forms a separate chains of execution. The event is put on the task queue and will be execute at some point by the task system. Event triggering is asynchronous.
The event may execute immediately, but don't rely on that. It can even be partially executed due to a Delay node.

Macros can be shapred between Blueprints using a Macro Library.


[does it makes difference if i make events Vs functions? @ reddit.com](https://www.reddit.com/r/unrealengine/comments/bfyia3/does_it_makes_difference_if_i_make_events_vs/)  
[Event/functions, what's the main difference between them? @ answers.unrealengine.com](https://answers.unrealengine.com/questions/391663/eventfunctions-whats-the-main-difference-between-t.html)  
[Managing complexity in Blueprints @ unrealengine.com/blog](https://www.unrealengine.com/en-US/blog/managing-complexity-in-blueprints)


[[2020-12-28_13:28:11]] [Blueprint events](./Blueprint%20events.md)  