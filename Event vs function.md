2020-07-04_20:32:29

# Event vs function

Functions have return values.
Functions can have local variables.
Events can use Delay and Timeline nodes.
Events can be replicated.
Event graphs can have multiple entry points and merging flow.
Events can have functions/other events bound to them. (Check this. What does it even mean?)

Functions represent an abstraction of a side effect or computation. It is executed immediately within the bounds of the calling graph/script. The calling script will not continue until the function has completed. Function calls are blocking.

An event forms a separate chains of execution. The event is put on the task queue and will be execute at some point by the task system. Event triggering is asynchronous.
(
I don't know if this is true or not.
All my testing so far show that the called event execute immediately, before the next node in the calling graph.
Don't know if that is guaranteed or not.
)


[does it makes difference if i make events Vs functions? @ reddit.com](https://www.reddit.com/r/unrealengine/comments/bfyia3/does_it_makes_difference_if_i_make_events_vs/)  
[Event/functions, what's the main difference between them? @ answers.unrealengine.com](https://answers.unrealengine.com/questions/391663/eventfunctions-whats-the-main-difference-between-t.html)  
[Managing complexity in Blueprints @ unrealengine.com/blog](https://www.unrealengine.com/en-US/blog/managing-complexity-in-blueprints)


[[2020-12-28_13:28:11]] [Blueprint events](./Blueprint%20events.md)  