2020-12-05_14:33:00

# Versioning classes

Versioning is used to get backwards compatibility.
We can do versioning of our classes by overriding the `Serialize` member function.
Serialize both stores and restores the class instance.
To keep track of what data we have in the various versions one can store a per-class data set ID.

`FArchive` stores a bunch of version numbers, each identified by a `FGUID`.
We can associate our own class with one such (`FGUID`, version sequence) pair.
For each new feature or other change to the class layout or format we increment the version number.
During read we check the version number and act accordingly.

`MyCustomVersion.h`:
```cpp
#pragma once

#include "CoreMinimal.h"
#include "Misc/Guid.h"

/// Struct that holds the version number we have created so far.
struct MYPROJECT_API FMyCustomVersion
{
    enum Type
    {
        // When restoring an instance older than when versioning was introduced
        // the engine will set the version to zero, so don't use that for the
        // first feature version number.
        BeforeCustomVersionWasAdded = 0,

        // Monotinically incrementing version numbers. Only add at the end.
        Feature1Added = 1,
        Feature2Added = 2,
        Feature3Added = 3,

        // Some meta-data values. Don't change.
        OnePastLast,
        LatestVersion = OnePastLast - 1
    };

    // The GUID for this custom version series.
    const static FGuid GUID;
};
```

`MyCustomVersion.cpp`:
```cpp
#include "MyCustomVersion.h"
#include "Serialization/CustomVersion.h"

// Pick a unique GUID for this version series.
const FGuid FMyCustomVersion::GUID(/*HEX*/, /*HEX*/, /*HEX*/, /*HEX*/);

// Register the custom version with the engine.
FCustomVersionRegistration GRegisterMyCustomVersion(
    FMyCustomVersion::GUID,
    FMyCustomVersion::LatestVersion,
    TEXT("MyVersion"));
```

```cpp
void AMyActor::Serialize(FArchive& Archive)
{
    // Store all the properties, meta-data, and whatever else the engine needs.
    Super::Serialize(Archive);
    
    // Alias to the version series ID, just to cut down on the typing.
    FGUID& GUID = FMyCustomVersion::GUID;

    // Tell the archive which versions series to use.
    Archive.UsingCustomVersion(GUID);

    // Ask the archive for which version it was created with.
    int32 ArchiveVersion = Archive.CustomVer(GUID);
    
    /// \todo I don't quite understand this part yet.
    /// What are Feature1, Feature2, and Feature3?
    if (ArchiveVersion >= FMyCustomVersion::Feature1Added)
        Archive << Feature1;
    if (ArchiveVersion >= FMyCustomVersion::Feature2Added)
        Archive << Feature2;
    if (ArchiveVersion >= FMyCustomVersion::Feature3Added)
        Archive << Feature3;
}
```

[VersioningAssetsAndPackages @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/VersioningAssetsAndPackages/index.html)  
