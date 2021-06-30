2021-06-17_18:27:56

# Engine association

Each project is associated with an Unreal Engine version or installation.
This is stored in the project's `.uproject` file as `EngineAssociation`.
This is what makes it possible to double-click a `.uproject` file and have it open to correct version of Unreal Editor.
It is either an UUID string, such as `"{000438DA-08D8-E173-2322-DD9C4256781A}"` or a version string, such as `"4.25"`.
It may be possible to have a path to the Unreal Engine installation directory instead of a version or an UUID.
Maybe even a relative path, making it possible to distribute project+engine as one package/repository.

On Linux, a list of all installed engines are kept in `~/.config/Epic/UnrealEngine/Install.ini`.
There is likely a similar file on other platforms as well.
It can look something like the following:
```
[Installations]
{000438DA-08D8-E173-2322-DD9C4256781A}=/media/s800/UnrealEngine_4.25
```
The path must not contain a trailing slash.
It is tempting to give the installation a more readable name, by replacing the UUID string in `Install.ini`, but I've been told this doesn't work and that only UUID-type strings are supported.

[[2020-12-15_16:04:11]] [Managing multiple projects](./Managing%20multiple%20projects.md)  
