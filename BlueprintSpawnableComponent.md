2020-04-03_09:37:12

# BlueprintSpawnableComponent

This metadata specifier, i.e., an attribute of the `Meta` class speficier, make the class spawnable by a Blueprint.
The class must be a subclass of `UActorComponent`.
This attribute is required in order to be able to add the component to an `Actor` using the `Add Component` button, or using the `NewObject`+`AddInstanceComponent`+`RegisterComponent` member functions.

[[2020-03-09_21:54:48]] [col] Blueprints