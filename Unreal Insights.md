2020-10-08_08:42:31

# Unreal Insights

Unreal Insights is a performance profiler used to identify bottlenecks and help optimize a target application for better performance.
Collects, analyzes, and visualizes data emitted by the engine.
Data can be recorded remotely to minimize the impact of the collection.
That is, one machine runs the target application and another runs Unreal Insights.
This is the recommended way.

Unreal Insights is started by running `./UnrealInsights` from `$UE_ROOT/Engine/Binaries/Linux`.

The game should be started with
`-tracehost=127.0.0.1 -trace=frame,cpu,gpu`

So far, starting the game with
```
./UE4Editor <PROJECT_PATH>/<PROJECT_NAME>.uproject /Game/<LEVELS DIR>/<LEVEL_NAME> -Game -tracehost=127.0.0.1 -trace=frame,cpu,gpu
```
rather then with Play In Editor seems to work better. Maybe.
`<LEVEL_NAME>` should not include the `.umap` suffix.
A stand-alone application is probably best. Haven't tested much yet.


## Frontend and session management
Called Browser Mode.
Start the target application, i.e. the game or Unreal Editor, with `-tracehost=<IP of Unreal Insights machine>`.
Unreal Insights must be started before the target application because the target application will try to connect during startup.
Not sure if this means the entire Unreal Editor, or just when pressing Play.
Supports user-provided samplings points for application-specific code.
The Unreal Insights GUI is split into three parts:
- Trace Sessions.  
    List of pre-recorded sessions that can be loaded for analysis.
- Trace Store Directory.  
    File system location for the recorded sessions. Stores `.utrace` files.
- New Connection.  
    Experimental, do not use. Start Unreal Insights before the target application, and pass `-tracehost=<IP of Unreal Insights machine>` to the target application.

Each recorded trace session corresponds to a `.utrace` file in the Trace Store Directory.
A trace session is opened by double-clicking it in the Trace Sessions list.
A currently running target application instance has `LIVE` in the Status column.
These update in real-time while open.
Otherwise identical to pre-recorded trace sessions.

## Session analysis
Called Viewer Mode.
The session viewer is a separate process.
Has three tabs:
- Session Info.
    Shows per-frame performance data for the CPU and the GPU.
- Timing Insighs.
- Asset Loading Insights.



[UnrealInsights@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Performance/UnrealInsights/index.html)  
[Collect, Analyze, and Visualize Your Data with Unreal Insights | Unreal Fest Online 2020@youtube.com](https://www.youtube.com/watch?v=Rf6oNkcGmX4)  
[Unreal Insights | Live from HQ | Inside Unreal@youtube.com](https://www.youtube.com/watch?v=TygjPe9XHTw)  
