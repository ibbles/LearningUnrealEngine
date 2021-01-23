2020-08-18_13:36:50

# Wait for user input

(
I don't understand the purpose of this.
Or rather, it seems like there should be a better way.
Perhaps there is a requirement I'm forgetting.
)

We want a get-ready type of screen.
We want to wait for the user to click a button and then call a worker function.

Create a looping timer.
Bind an Input Event to a function that clears the timer and calls the worker function.

[Using timers in UE4 @ www.tomlooman.com](https://www.tomlooman.com/using-timers-in-ue4/)
