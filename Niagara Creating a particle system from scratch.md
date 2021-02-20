2021-02-20_12:13:48

# Creating a particle system from scratch


The goal is to create a particle emitter maintains a fixed number of particles.
We do this by having a target number of particles parameters and every now and then checking the current number of particles and if too low create create a bunch of new ones.

Right-click in the `Content Browser`, select `FX` → `Niagara Emitter`.
The created emitter has all the sections, orange, green, and red, and all the groups within the sections.
The only pre-created module is `Emitter Properties`, which is identical to the burst template.

Right-click in the `Content Browser` again and select `FX` → `Niagara Module Script`.
Name it `SpawnSomeParticles`.