2021-06-05_18:25:22

# Rate limiting

Many things in a game need to happen repeatedly.
An easy way to achieve this is to do the things in the Tick event.
Drawback of this is that the things we be done at an uneven rate, since the frame time varies, and the things may be done unnecessarily frequently which results in lower-than-possible performance.
There are alternatives to the Tick event.

*Do Once + Delay + Do Once Reset*
This configuration is useful when an action can be requested at any time from some external source and we want to block the action if it was recently performed.
Put a Do Once node before the execution nodes that are to be rate limited.
Put a Delay node after the execution nodes.
Wire out output execution pin of the Delay node into the Reset input pin of the Do Once node.
Now execution will pass the Do Once node only once every `Delay` seconds.

*Timer*
For actions that should be taken at a steady rate a Timer can be used.

[[2021-03-10_10:35:35]] [Timer](./Timer.md)

