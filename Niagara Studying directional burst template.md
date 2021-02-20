2021-02-20_12:09:27

# Niagara Studying directional burst template

The main part of a particle system is one or more emitters.
Let's study the `Directional Burst` template emitter.
It is created by right-clickig in the `Content Browser`, expanding `FX` and selecting `Niagara Emitter`.
From the emitter creation dialog select the `Directional Burst` template.

Opening the emitter we see that it consists of three main parts: a timeline, a set of parameters, and a stack of modules.
The module stacks are what defines the behavior of the emitter.
It consists of three sections, each with it's separate color.
Orange is for the emitter itself, green is for the emitted particles, and red is for rendering. Each colored part contains a collection of groups, and each group contains a stack of modules.

The orange Emitter section conists of the `Emitter Spawn` group and the `Emitter Update` group.
The first is executed when the emitter is created and the second on every tick.
The `Emitter Spawn` group created by the `Directional Burst` template contains a single module named `Emitter Properties`.
This is where we can set various general properties of the emitter.
The `Emitter Update` group contains two modules: `Emitter Life Cycle` and `Spawn Burst Instantaneous`.
`Emitter Life Cycle` seems to be a set of general emitter properties much like the `Emitter Properties` under `Emitter Spawn`.
The `Spawn Burst Instantaneous` modules is half of what defines this emitter.
This is where we define the number of particles that should be spawend in each burst, with the `Spawn Count` parameter.
I don't understand why that number of particles isn't spawned every tick.
What defines when it's time to spawn again?

The second section is the green `Particle Spawn`.
It contains the modules that should execute for each spawned particle.
The first module is `Initialize Particle`.
This can be considered a particle constructor.
Here we can set things such as lifetime, mass, color, and sprite size.
Unfortunately, changing the sprite size has no effect on the size of the particles.
`Mesh Scale` doesn't seem to do anything either.
I don't know what's up with that.
OK I got it, the next module in the `Particle Spawn` group is `Calculate Size by Mass`.
I'm guessing this is overwriting the values I set in `Initialize Particle`.
The last module in the `Particle Spawn` group is `Add Velocity in Cone`.
It gives each particle a random velocity within a cone.
The oddity here is that even with the same minimum and maximum `Velocity Strength` and a very narrow `Cone Angle`, some particles fly much farther and others.
I don't know why.
OK I got it, it's the `Velocity Fallof Away From Cone Axis` checkbox.
Moving on to the `Particle Update` group we find a number of modules related to particle simulation.
`Update Age` reduces the lifetime or particles and kill too old particles.
`Gravity Force` adds a gravity force to each particle.
`Drag` adds a drag force to each particle.
`Scale Color` scales the alpha channel of the particles so they fade out over their lifetime.
This doesn't seem to do anything. The particles disappears suddenly at the end of life no matter what alpha curve I set.
Isn't alpha supported by the renderer?
I switched, under `Rendering`, the `Material` from `DefaultSpriteMaterial` to `DefaultSpriteMaterial` and now the alpha curve works again.
`Solve Forces and Velocity` uses the forces we've added to compute new positions and velocities.
`Sprite Size Scale by Velocity` makes fast particles larger, I think.

The last section is the red one, which consists of the single `Render` group.
This one has a lot of parameters and toggles.

Having finished reading through the burst template, I was never able to figure out why `Spawn Count` particles wasn't spawned every tick by the `Spawn Burst Instantaneous` module in `Emitter Update`.
Invastigating another emitter template, a more continious one, to see what that emitter does differently.
Creating a particle system from a `Fountain` emitter.


## Comparing Direction Burst and Fountain

They both have the same `Emitter Spawn` → `Emitter Properties`.
Under `Emitter Update` → `Emitter Life Cycle`, the fountain has 0 `MaxLoopCount` and 5.0 `NextLoopDuration`, compared to the directional burst's `MaxLoopCount` of 10 and `NextLoopDuration` of 1.44....

Instead of `Spawn Instantaneous`, the fountain has a `Spawn Rate`.
This seems like an important difference.