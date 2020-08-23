2020-08-18_13:44:36

# Serialization

```
## JackToday at 12:43 PM

> I'm using FArchive to serialize UObject, but it serializes all the properties in it. I need to serialize only those, which are tagged with SaveGame flag

@Flakky did you set the ArIsSaveGame flag on the archive?

_\[_12:44 PM_\]_

Also wouldn't suggest using a stock Farchive for save games, the proxy archives are usually better suited

![ ](https://cdn.discordapp.com/avatars/233154673769578496/1931b537778dfcfb099cc61a62edd439.png?size=128)

## FlakkyToday at 12:52 PM

@Jack I'm using FArchive to save uobjects, as well as transportation them over the network.

_\[_12:52 PM_\]_

Why you do not recomment using FArchive?

![ ](https://cdn.discordapp.com/avatars/502900058375716864/4e8238f35e8746b6008fe9bd90160ab1.png?size=128)

## MaliDev-manToday at 12:52 PM

@NoCodeBugsFree i think Async Scene was removed in 4.21 so u don't need that . just remove it(edited)

![ ](https://cdn.discordapp.com/avatars/107794086563446784/5ed64b756eeca9712a26308094af02f6.png?size=128)

## JackToday at 12:55 PM

Couple of reasons: 1) how they handle live ptrs, assets and class's is usually better and with `FObjectAndNameAsStringProxyArchive` you also get the option to load the class, asset etc when loading back the data 2) Usually the Archive itself is an archive wrapped in another archive, i.e you're using a memory writer to write out your save data to a byte array (TArray&lt;uint8&gt;) and then storing that byte array in your save game. Proxy archives allow that behaviour of an archive wrapped in another archive. So you use the same outer archive to save AND load

![ ](https://cdn.discordapp.com/avatars/233154673769578496/1931b537778dfcfb099cc61a62edd439.png?size=128)

## FlakkyToday at 12:55 PM

@Jack

    TArray<uint8> BinaryData;    
    FMemoryWriter Writer(BinaryData);
    FObjectAndNameAsStringProxyArchive Archive(Writer, true);
    Object->Serialize(Archive);

I save like this(edited)

![ ](https://cdn.discordapp.com/avatars/107794086563446784/5ed64b756eeca9712a26308094af02f6.png?size=128)

## JackToday at 12:56 PM

Awesome, using the right thing

_\[_12:56 PM_\]_

jsut be sure to set ArIsSaveGame on the FObjectAndNameAsStringProxyArchive
```

