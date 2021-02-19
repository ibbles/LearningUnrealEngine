2021-02-19_19:49:10

# Module loading phase

When declaring a module in `.uproject` we specify a `LoadingPhase`.
This determines when the module is loaded during engine startup.

Common values are:
- `Default`: During engine init, after game modules are loaded.
- `PostEngineInit`: After the engine has been initialized.

[ELoadingPhase::Type @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/API/Runtime/Projects/ELoadingPhase__Type/index.html)  