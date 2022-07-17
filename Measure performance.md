2020-11-21_15:49:56

# Measure performance

## Stats

Numbers for things displayed on screen.
Viewport top  left drop-down menu > Stat > Long list of things that can be shown.
There are console commands for these as well.
- `stat none`: Clear the screen of all statistics.
- `stat scenerendering`: A summary of the scene rendering, both timing and contents.
- `stat game`: Blueprint time and such.
- `stat fps`: The framerate.
- `stat unit`: Milliseconds per thread. Useful for knowing where to start looking for bottlenecks.

## Level editor viewport

Different types of view modes.
Level Editor > Viewport > View Mode (top-left, third button) > Optimization Viewmodes

Shader complexity shows how expensive each surface is.



## Console commands

`stat fps`: Show current fps.
`stat unit`: Show time per thread.
`stat unitgraph`: A plot of filtered times for Frame, Game, Draw, and GPU.
`stat scenerendering`: A table with a bunch of rendering related data.
`stat DumpFrame -ms=0.1`: Not sure. Also not sure if the `-ms` part is is separate from the `DumpFrame` part.

## GPU Visualizer

Opened with Ctrl+Shift+,.
GPU Profiler or Profile GPU.
A visual representation of some of the Stat data for a particular frame.
It's a snapshot.


## Statistics panels

Top Menu Bar > Window > Statistics.
A table with a bunch of data.
Contains a few different tables that can be switched between.
Can select Actors from the table rows.

## Unreal Insights

Built-in visual profiler.
[[2020-10-08_08:42:31]] Unreal Insights


## System profiler


### Linux

##### Perf

`perf` is a sampling profiler.
On Ubuntu, install one of the `linux-toolslinux-tools` packages.
If you don't have it already, then running `perf` will tell you which one you need to install.

For security reasons Ubuntu doesn't allow processes to attach to each other arbitrarily so we must disable this check to allow sampling.
```
echo 0 | sudo tee /proc/sys/kernel/perf_event_paranoid
```
See also [Perf Security @ kernel.org](https://www.kernel.org/doc/html/latest/admin-guide/perf-security.html).

Run one of the following, depending on what version of Unreal Engine your are using.
```
perf record -g -p (pidof UE4Editor) sleep 30
perf record -g -p (pidof UnrealEditor) sleep 30
```

This will record samples for 30 seconds, so what whatever it is you want to measure.

After the 30 seconds has passed, run
```
perf report -g --no-children
```



[[2020-10-08_08:42:31]] [Unreal Insights](./Unreal%20Insights.md)  
