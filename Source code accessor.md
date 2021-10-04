2021-07-09_09:02:27

# Source code accessor

Unreal Editor links C++ projects to an IDE and a compiler.
How that link works varies from IDE to IDE.
Knowledge of a particular IDE  lives in a Source Code Accessor plugin for that IDE.
The Accessor plugins are stored in `$UE_ROOT/`.

## Unreal Engine 4.25 on Linux NullSourceCodeAccessor bug

In 4.25 there was a bug on Linux that caused Unreal Engine to say that there are no source code accessor, `NullSourceCodeAccessor`, when creating and packaging projects.
This happened because it searched for Clang in the system directories instead of the local build tool chain.
A work-around is to install the Clang system package, `sudo apt install clang`, then the engine will will that Clang and happily continue.
The system Clang installation is never used, this was simply a sanity check bug.