2020-12-11_12:25:02

# Raw texture data in C++

(
This entire note is just guesses.
)

To read data from a texture one must first force the data to be resident and then lock it.
These operations must be performed on the render thread.

[[2020-08-31_16:29:29]] [Render commands](./Render%20commands.md)  

To get a pointer to texture data do the following:
```cpp
FByteBulkData& BulkData = MyTexture->PlatformData->Mips[0].BulkData;
BulkData.ForceBulkDataResident();
const FColor* Pixels = reinterpret_cast<const FColor*>(bulkData.LockReadOnly());
check(Pixels);
```

There is also a ReadWrite version:
```cpp
FByteBulkData& BulkData = MyTexture->PlatformData->Mips[0].BulkData;
FColor* Pixels = reinterpret_cast<FColor>(BulkData.Lock(
    EBulkDataLockFlags::LOCK_READ_WRITE));
check(Pixels);
```

I don't know when, if at all, `ForceBulkDataResident()` is required

When you are done with `Pixels` return it to the texture with

```cpp
BulkData.Unlock();
```

There is also `TextureMipGenSettings::TMGS_NoMipmaps` that may be interesting.

[[2020-08-31_16:29:29]] [Render commands](./Render%20commands.md)  