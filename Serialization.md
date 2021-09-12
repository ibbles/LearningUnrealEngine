2020-08-18_13:44:36

# Serialization

Archive, implemented in the `FArchive` class, is used to serialize UObjects.
By default Archive serializes all UProperties.
The serialization behavior can be controlled per UProperty using Property Specifiers.
The Transient Property Specifier excludes the UProperty from serialization.
There is a whole bunch of similar Property Specifiers with various effects.
I assume that a non-serialized UProperty get the default value from the Class Default Object, or possibly retains its current value.

Serialization reads handle changes to the serialized class automatically.
New UProperties that doesn't exist in the archive is read from the Class Default Object instead.
Old UProperties that doesn't exist in the class anymore are silently ignored.

To get more control over the serialization process override the `UObject::Serialize` virtual member function.

FName must be serialized with `FNameAsStringArchive`.


## Serializing to memory

```cpp
FSaveMyStruct MyStructInstance;
MyStructInstance.AnyInt32 = 77;
FBufferArchive Buffer(true);
StaticStruct<FSaveMyStruct>()->SerializeBin(Buffer, &MyStructInstance);
TArray<uint8> Bytes = Buffer;
```



## Save games

We can restrict it to only store UProperties marked with the SaveGame UProperty Specifier.
Archive as a flag named `ArIsSaveGame` that can be set.

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

[[2021-01-26_11:00:02]] [Save game](./Save%20game.md)  
[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2021-06-22_08:34:55]] [UProperties](./UProperties.md)  


[Uobject ustruct serialization @ ikrima.dev](https://ikrima.dev/ue4guide/engine-programming/uobject-serialization/uobject-ustruct-serialization/)  
