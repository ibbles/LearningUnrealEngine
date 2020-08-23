2020-08-22_13:21:00

# RF_Transactional

This is one of the object flags.
I don't know what it does or what it's for.
The official documentation is literary `Object is transactional.` which gives no additional informaiton.
The `Transactions` section of the official documentation talk about undo/redo so perhas transactional objects are those that store old states in the undo history?
[https://docs.unrealengine.com/en-US/BlueprintAPI/Transactions/index.html](https://docs.unrealengine.com/en-US/BlueprintAPI/Transactions/index.html)

I the Unreal Slackers discorde I saw the following comment

```
// not sure what this is but it's named "/Temp/Untitled" and only has the RF_Transactional object flag
// indicates that we're in the editor (and not in PIE either)
if (Outer->GetFlags() == RF_Transactional)
```

which would mean that we should set the `RF_Transactional` flag on objects we create while we're editing in the Editor and not setting the flag in Play mode.