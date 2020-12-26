2020-11-27_12:25:50

# C++ snippets

A collection of C++ snippets.
Move these to dedicated documents once we have enough text to write.

Looping over all actors of a particular type:
```c++
for (AMyActor* MyActor : TActorRange<AMyActor>(World)
{
}
```