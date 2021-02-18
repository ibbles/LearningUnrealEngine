2021-02-17_21:51:31

# JSON

Unreal Engine has built-in JSON reader and writer functions.

## Reading
Consider the following example JSON document, stored in a file named `MyJSON.json`.
```json
{
    "NestedObject": {
        "FirstMember": "This is a string",
        "SecondMember": 5.4
    }
}
```

```cpp
#include "Misc/FileHelper.h"
#include "Json.h"

// Read the JSON document. This could also be from a network or any other source.
FString FileName("MyJSON.json");
FString JSONString;
if (!FFileHelper::LoadFileToString(JSONString, *FileName))
{
    return;
}

// Create a Reader and use it to deserialize the JSON document.
TSharedPtr<FJsonObject> Json;
TSharedRef<TJsonReader<>> Reader = TJsonReaderFactory<>::Create(JSONString);
if (!FJsonSerializer::Deserialize(Reader, Json))
{
    return nullptr;
}
if (Json == nullptr)
{
    continue;
}

// FJsonObject contains various Get.+Field methods to navigate into the document.

// We use FJsonObject::GetObjectField to get a nested object.
// Notice that the type is the same as for the entire JSON document.
const TSharedPtr<FJsonObject>& NestedObject =
    Json->GetObjectField(TEXT("NestedObject"));

// We use FJsonObject::GetStringField to get strings.
FString FirstMember = NestedObject->GetStringField(TEXT("FirstMember"));

// We use FJsonObject::GetNumberField to get numbers.
double SecondMember = NestedObject->GetNumberField(TEXT("SecondMember"));

// There are other Get.+Field member functions as well.
```

[Using Json in Unreal Engine 4](http://www.wraiyth.com/?p=198)  
