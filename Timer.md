2021-03-10_10:35:35

# Timer

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

[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  
[[2020-06-29_13:29:35]] [Events](./Events.md)  
[[2021-03-10_10:42:34]] [Delegate](./Delegate.md)  