2020-10-03_11:24:21

# Macros

Unreal Header Tool, a part of Unreal Build Tool, will look for these macros when parsing header files during a project build.

- `UCLASS`: Expose a class to Unreal Engine. [[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)
- `UPROPERTY`: Expose a non-static data member of a `UCLASS` class to the engine. [[2020-03-09_21:43:36]][UPROPERTY](./UPROPERTY.md)
- `UFUNCTION`: Exposes a non-static member function of a `UCLASS` class to the engine. [[2020-03-09_21:48:56]] [UFUNCTION](./UFUNCTION.md)
- `*_API`: Export a `UCLASS` for use in other modules.
- `GENERATED_BODY`: Engine-related `UCLASS` declarations.