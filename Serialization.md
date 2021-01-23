2020-08-18_13:44:36

# Serialization

`FArchive` is used to serialize `UObject`s.
By default `FArchive` serializes all `UPROPERTIES`.
We can restrict it to only store `UPROPERTIES` marked with `SaveGame`.
`FArchive` as a flag named `ArIsSaveGame` that can be set.

There is also something called proxy archives (`FObjectAndNameAsStringProxyArchive` I think) that are often better for save games:
- Handle live pointers, assets, and classes better.
- Get the option to load the class, asset, etc when loading back the data.
- Allow archives wrapped in other archives, i.e., writing a subset of the data into a `TArray<uint8>` using a memory writer and then storing the `Tarray<uint8>` into the outer archive.
- Can use the same outer archive to both save and load.

```cpp
TArray<uint8> BinaryData;    
FMemoryWriter Writer(BinaryData);
FObjectAndNameAsStringProxyArchive Archive(Writer, true);
Object->Serialize(Archive);
```
