2020-04-12_15:21:07

# Communication

There are many ways data can be distributed and accessed.

To access an Actor variable within that Actor's Event Graph Blueprint, drag the variable from the Variables list in the My Blueprint tab into the Event Graph Blueprint.
To access an Actor Component within that Actor's Event Graph Blueprint, drag the Component from the Components tab into the Event Graph Blueprint.
For this to work on C++ Actors the Component `UPROPERTY` must be marked BlueprintReadWrite or BlueprintReadOnly and VisibleAnywhere or EditAnywhere, and the type's `UCLASS` or `USTRUCT` must be marked Blueprintable or be a primitive type.
To access a Blueprint variable or Component from another Blueprint you must have a reference to that Actor.
One way to get a reference is to call Get All Actors Of Class.
Another is to Spawn a new Actor with SpawnActor.
Another is to call one of the public getter functions, such as Get Game Mode, Get Player Character, get Controlled Pawn or Get Player Controller.
Another is to get one from a system event, such as ActorBeginOverlap.

There are two ways to jump flow of execution: Events and Functions.
Events is a named entry point in a Blueprint while functions are their own Blueprint tab.
Both can have inputs, but events cannot have outputs.
From an AIController Actor's Event Graph Blueprint I can call AI Move To from an Event but I cannot call it from a function within the same AIController Actor.
Don't know why.
Maybe I would be able to if I used a macro instead of a function.
Both functions and events can be called repeatedly using Set Timer By Function Name.
There is also Set Timer By Event. Not sure why By Function can call an event when there is a By Event timer type.
This is used frequently by tutorials.

## Blueprint Interface

A Blueprint Interface is a set of functions that Blueprint classes implementing the interface must provide.


Blueprint Interfaces can be used to send messages between a sender and a receiver.
The sender has a variable holding one or more references to instances of the Blueprint Interface.
The receiver implements the Blueprint Interface.
(
In this Unreal Engine live stream they make the variable hold Actors instead of using the Blueprint Interface.
Why?
[Oct 4, 2018 Unreal Livestream Makeup video by Zak Parrish @ youtube.com](https://youtu.be/M0MpyfFaPsA?t=4414)
)
When there is a new message to transmit the sender call one of the functions listed in the Blueprint Interface.
A Blueprint Interface call node in a Visual Script is blue and decorated with an open envelope symbol.


[[2021-06-05_16:16:53]] [Blueprint interface](./Blueprint%20interface.md)  


## Twin stick shooter

The communication flow for AI movement in the TwinStickShooter is as follows:
There is an EnemyCharacter class inheriting from BaseCharacter inheriting from Character.
There is an EnemyAI Blueprint class inheriting from AIController.
The EnemyCharacter has the EnemyAI class as its AI Controller Class.
The EnemyAI BeginPlay event calls Set Timer by Function Name for the TrackPlayer event.
The TrackPlayer event in EnemyAI calls AI MoveTo, passing in the EnemyCharacter and the Player Character.

The communication flow for player movement in the TwinStickShooter is as follows:
There is a HeroCharacter class inheriting from BaseCharacter inheriting from Character.
In Project Settings → Project → Maps & Modes Default Pawn Class is set to HeroCharacter.
In Project Settings → Engine → Input a number of Axis Mappings are made.
In the HeroCharacter Event Graph Blueprint there is an Event for each Input.
The events either simply pass them to Add Movement Input or Set Control Rotation.
The HeroCharacter has a CharacterMovement Component inherited from Character.
It is a built-in Component that will pick up the Add Movement Input and Set Control Rotation calls.


[BlueprintCommsUsage@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Engine/Blueprints/UserGuide/BlueprintCommsUsage/index.html)

[[2020-04-10_21:40:28]] [~Collection Twin stick shooter](./%7ECollection%20TwinStickShooter.md)  
