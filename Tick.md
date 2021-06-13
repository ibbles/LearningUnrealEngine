2020-12-30_19:06:05

# Tick

A "tick" is when the game world is moved from one state to the next.
It often corresponds to the change from one frame to the next.


## Tick event

Many classes, such as Actor and Component, has a Tick callback function (c++) or event (Blueprint).
The function/event is called Tick most of the time, but `TickComponent` on a C++ Component.
This function takes a `float DetalTime` parameter, which is the amount of time that has passed since the previous tick.

Ticking can be disabled on a particular type or instance.
Ticking costs some performance, so it's advantageous to turn it off whenever possible.
For a Blueprint, uncheck Class Defaults > Actor Tick > Start with Tick Enabled.
For a C++ class, set `Primary(Actor|Component)Tick.bCanEverTick` to `false`.


## Custom tick callbacks

`FTicker`, and in particular `FTicker::GetCoreTicker.AddTicker`, can be used to register a tick callback.
The callback should return `true` if it want to be called again, and `false` for one-off callbacks.
```cpp
/**
Arrange to have Callback be called during Tick at some point in the future.
A Delay of zero means at the next frame.
*/
void DelayedCall(TFunction<void()> Call, float Delay)
{
    check(IsInGameThread());
    FTicker::GetCoreTicker().AddTicker(
        FTickerDelegate::CreateLambda([=](float)
        {
            Call();
            return false; // Don't repeat this callback.
        }), Delay);
}
```