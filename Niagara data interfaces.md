2020-12-26_20:25:00

# Niagara data interfaces

Data interfaces is an extensible system to allow access to arbitrary data, including meshes, audio, DDC information, code objects and text containers.
Used to send arbitrary external data into a particle system.
The data is made accessible in the Modules.
One example is the Houdini plugin, which can pre-simulate a rigid body simulation which is imported into Unreal Engine. With the simulation comes events for things such as body breakage, impact positions, body velocities, etc. These can be used as events in the particle system.
