2020-06-29_13:29:35

# Events

Events are like callbacks. They are triggered and when triggered a Blueprint script is run.
Common events are BeginPlay and EventTick.
Other events are OnComponentOverlap(?).
Events are red nodes in the event graph.
Events have inputs but no outputs because they are asynchronous.
Events have an execution pin that connect to the graph that implements some functionality.
Events have an Output Delegate. I don't know what that is yet.

The difference between an event and a function is that events are asynchronous.
The calling code puts the event in a queue and then continues immediately.
The queued event is executed at some later time.

Custom events can be created.
A custom event is like a member function in a Blueprint class.
Each has a name.

Events can be bound using an event dispatcher node and a CreateEvent node.
In the CreateEvent node, select the wanted custom event from the drop down.
Used in 3 Prong Gaming's RTS tutorial to make construction proxies aware of changes in the game speed.

There are Event Dispatchers which are used to trigger events.
These are called `Delegates` in C++.

Unreal Editor contains a whole bunch of global Editor Events that can be listened for.

[[2021-06-29_16:07:25]] [Useful events](./Useful%20events.md)  



[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  
[[2021-03-10_10:35:35]] [Timer](./Timer.md)  
[[2021-03-10_10:42:34]] [Delegate](./Delegate.md)  
[[2020-05-10_18:32:07]] [Custom event](./Custom%20event.md)  
[[2021-06-29_16:07:25]] [Useful events](./Useful%20events.md)  
