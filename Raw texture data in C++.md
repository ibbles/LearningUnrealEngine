2020-12-11_12:25:02

# Raw texture data in C++

(
This entire note is just guesses.
)

To read data from a texture one must first force the data to be resident and then lock it.
These operations must be performed on the render thread.
(
How do one run something on the render thread?
)

```cpp
FByteBulkData& bulkData = MyTexture->PlatformData->Mips[0].BulkData;
bulkData.ForceBulkDataResident();
const FColor* pixels = reinterpret_cast<const FColor*>(bulkData.LockReadOnly());
check(pixels);
```

There is also `TextureMipGenSettings::TMGS_NoMipmaps` that may be interesting.