2021-05-30_13:05:35

# Object instantiation

There are many contexts in which objects are being instantiated.

## Actor duplicated when starting a Play In Editor session

When a Play In Editor session is started the engine creates a Play World and all Actors in the editor World is duplicated into it.
The Actors are duplicated by first serializing the editor Actors, then creating new Actors in the game World, and finally deserializing.
When an Actors is created it is first constructed using the C++ constructor, either the default constructor or the one taking an Object Initializer.
After the constructor has completed the Actor's Properties are initialized from the Class Default Object (CDO).
This is done by the Object Initializer destructor.
The properties are initialized using `operator=` for the property type, which may be a `USTRUCT`.

[[2020-03-10_21:12:12]] [USTRUCT](./USTRUCT.md)  

So the order is:
- Create game World.
- Duplicate Actors.
    - Serialize the editor Actor.
    - Create the game Actor using C++ constructor.
    - Copy Properties from the Class Default Object (CDO) to the game Actor.
    - Deserialize the editor Actor data into the game Actor.

It's not clear to me where in this list a Blueprint Construction Script is run.

## Actor modified from the Details Panel during Play In Editor

## Actor created with `SpawnActor` during gameplay

## Actor created during launch of packaged project