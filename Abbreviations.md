2021-03-09_20:33:40

# Abbreviations

- `CDO`: Class Default Object.
  A default constructed, i.e., with the default C++ constructor, instance of a class that Unreal Engine uses as a template when creating new instances of that class.
- `SCS`: Simple Construction Script.  
    A graph of Actor Components to instantiate.
    A Blueprint has one of these to represent all the ActorComponents that has been added in the Blueprint Editor or inherited from the parent class.  
    [USimpleConstructionScript @ docs.unrealengine.come](https://docs.unrealengine.com/en-US/API/Runtime/Engine/Engine/USimpleConstructionScript/index.html)  
    [UBlueprint::SimpleConstructionScript](https://docs.unrealengine.com/en-US/API/Runtime/Engine/Engine/UBlueprint/SimpleConstructionScript/index.html)
- `UCS`: User Construction Script.  
    A function in Actor.  
    Construction script, the place to spawn components and do other setup.
- `BPGC`: Blueprint Generated Class.