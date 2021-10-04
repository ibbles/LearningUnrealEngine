2021-09-15_15:29:16

# gdb


## FName

This prints the string held by an `FName`.

> This is how you can print FName, where 0 is the Comparison index:
```cpp
p ((FNameEntry&)GNameBlocksDebug[0 >> FNameDebugVisualizer::OffsetBits][FNameDebugVisualizer::EntryStride * (0 & FNameDebugVisualizer::OffsetMask)]).AnsiName
```

I don't quite understand this. Is a comparison index something held by each `FName` instance? How do I get that?
Let's split it up a bit.
The compare index seems to hold more than just an index, so calling it `NameInfo` below.
```cpp
auto NameInfo = /* FName instance specific index. */;
auto Idx1 = NameInfo >> FNameDebugVisualizer::OffsetBits;
auto Idx2 = FNameDebugVisualizer::EntryStride * (NameInfo & FNameDebugVisualizer::OffsetMask);
((FNameEntry&)GNameBlocksDebug[Idx1][Idx2]).AnsiName
```

So `GNameBlocksDebug` is a global two-dimensional array of `FNameEntry`.
Some of the bits of `NameInfo` holds the two indices.
The first index is in the highest bits of the value, which we bring down to the bottom, and zero the top, by shifting by `FNameDebugVisualizer::OffsetBits`.

An overview. I don't know the actual number of bits in each section, these are just examples.
```
 3         2         1
10987654321098765432109876543210
|   Idx1   |    OffsetBits     | Shift right until OffsetBits are gone and Idx1 is on the far left.
```
The second index lives in the lowest bits, so we can get it by masking away everything else
```
 3         2         1
10987654321098765432109876543210
              |     Idx 2      |
00000000000000111111111111111111  OffsetMask
```

## FString

For `FString` you can just do `p (TCHAR*)FString.Data`.