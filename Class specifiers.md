2020-12-30_17:24:55

# Class specifiers

Class specifiers are keywords that are added inside the parenthesis in `UCLASS()` macros.
The are read by the Unreal Header Tool and are used to control the behavior and properties of the class.

- `Blueprintable`: Allow creation of Blueprint subclasses of the C++ class.
- `BlueprintType`: Allow creation of variables of this type in Blueprint classes.
- `NotBlueprintable`: Do not allow creation of Blueprint subclasses of the C++ class.
- `ClassGroup`: Used by the Group View in the Actor Browser. Not sure what the Actor Browser is.

## Class metadata specifiers

Metadata specifiers only exist in the editor, they are removed in the cooking process.

- `BlueprintSpawnableComponent` - To make it possible to add instances of this ActorComponent to Blueprints and Actors in Unreal Editor.

[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  