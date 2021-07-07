2021-03-10_10:35:35

# Timer

## Blueprint

Timers are created from a Blueprint's Event Graph.
Create a new Timer with the Set Timer by Event and Set Timer by Function Name functions.

For *Set Timer By Event*, create the event that will be triggered by right-click the Event Graph background and select Add Custom Event.
A Custom Event is a Node Graph execution source that can be triggered manually, for example using a Timer.
Bind the Custom Event to the Timer by dragging a wire from the red square on the Custom Event node to the red square on the Set Timer by Event node.
Other way is to drag from the red square on the Set Timer by Event node onto a empty space, select Create Event from the menu, and select the name of the Custom event from the new node's drop-down menu.

The Set Timer functions return a *Timer Handle*.
That can be used to pause and unpause the timer.


[[2020-05-10_18:32:07]] [Custom event](./Custom%20event.md)  

## C++

This is how a Timer Delegate is used to register a timer callback in a World:
```cpp
FTimerDelegate TimerCallback;
TimerCallback.BindLambda([]()
{
    // Your code here.
});

FTimerHandle Handle;
GetWorld()->GetTimerManager().SetTimer(Handle, TimerCallback, 5.0f, false);
```

`FTimerDelegate` is an type that holds a function to execute, for example a lambda.
`TimerCallback` is an instance of the Delegate, so it holds a function to execute.
`FTimerHandle` is a link between some delegate trigger and the delegate.
`SetTimer` create that link, linking something inside the Timer Manager to `TimerCallback`, which in turn links to the function to execute.
The link is remembered in `Handle`, so we can sever the link later if we wish.

We can also have the timer call a member function:
```cpp
GetWorldTimerManager().SetTimer(Handle, this, &UMyClass::MyCallback, 5.0f, false);
```

[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  
[[2020-06-29_13:29:35]] [Events](./Events.md)  
[[2020-05-10_18:32:07]] [Custom event](./Custom%20event.md)  
[[2021-03-10_10:42:34]] [Delegate](./Delegate.md)  
