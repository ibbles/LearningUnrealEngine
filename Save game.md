2021-01-26_11:00:02

# Save game

Members must be marked `UPROPERTY` to be saved in a save game.
To save the game call
```cpp
bool UGameplayStatics::SaveGameToSlot(
    USaveGame* SaveGameObject,
    const FString& SlotName,
    const int32 UserIndex)
```

Don't know where one get a `USaveGame` from, what are legal `SlotName`s, or what the `UserIndex` is for.
There is also `UGameplayStatics::AsyncSaveGameToSlot`.

[[2020-08-18_13:44:36]] [Serialization](./Serialization.md)  