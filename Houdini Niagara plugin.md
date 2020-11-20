# Houdini Niagara plugin

Houdini's Niagara plugin allows you to exports kinematic particle data from Houdini and import that into Niagara.
The collection of particle data is called a Point Cache.
It can be stored in either human-readable or binary json files, identified by the `.hjson` or `.hbjson` file suffixes.
The Point Cache can be imported into the Content Browser 
Becomes a Houdini Point Cache Asset.

The plugin comes with an emitter type named Houdini Niagara Basic.
On the Unreal Engine side it is used by creating a Niagara System and add the Houdini Niagara Basic emitter.
The emitter contains a handful of nodes that need access to the point cache.
One way to set this up is to add a user attribute on the System.
Click `+` on the System node and under Add Parameter search for "Houdini Point Cache Info".
The parameter has a Houdini Point … property which can be assined to the imported Point Cache Asset.
Each Module that needs a Point Cache can be set to use the system attribute using the drow-down menu.
Niagara uses the point cache to sample Niagara particles at three times:
- Spawning particles.
- Position spawned particles.
- Updating particle positions on Update.






[[2020-11-18_17:39:27]] [Niagara](./Niagara.md)  