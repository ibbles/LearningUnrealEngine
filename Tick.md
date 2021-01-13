2020-12-30_19:06:05

# Tick

A "tick" is when the game world is moved from one state to the next.
It often corresponds to the change from one frame to the next.
Many classes, such as `AActor` and `UActorComponent`, has a `Tick` callback function.
This function takes a `float DetalTime` parameter, which is the amount of time that has passed since the previous tick.

`FTicker`, and in particular `FTicker::GetCoreTicker.AddTicker`, can be used to register a tick callback.
The callback should return `true` if it want to be called again, and `false` for one-off callbacks.
```cpp
/**
Arrange ot have Callback be called during Tick at some point in the future.
A Delay of zero means at the next frame.
*/
void DelayedCall(TFunction<void()> Call, float Delay)
{
    check(IsInGameThread());
    FTicker::GetCoreTicker().AddTicker(FTickerDelegate::CreateLambda([=](float)
    {
        Call();
        return false;
    }), Delay);
}
```