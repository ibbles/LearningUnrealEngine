2020-12-03_21:29:00

# Niagara systems
Systems are assets that live in the Content Browser.
Create a new system with Right Click > FX > Niagara System.
A System holds emitters that together produce an effect.
Systems are containers for multiple emitter.
A system produces one complete effect.
An example of an effect is a firework.
The emitters are choreographed using emitter sequencing in a timeline.
Can set which emitters loops and bursts and so on.
Systems have global variables that are available to the contained emitters.

There is a system editor in which emitters are added and configured.
The System Editor is very similar to the emitter editor.
There is one more Module Stack section, colored in blue, which contain the system level modules.
Here we add Modules that are global to the module.

New emitters are added using the `+ Track` button in the Timeline Panel.
Or through the System Overview context menu.
All emitters are listed as separate tracks in the Timeline Panel.
Here we control the relative timing between the emitters.

The added emitters can be modified to tweak the effect.
We can add and remove modules.
We can change parameter values on the modules.
The module stacks of the emitters can be modified by the system.
The green arrow next to each module parameter reverts back to the parent emitter's value for that parameter.
The yellow arrow resets to the default for the type of the parameter, which is often 0 of some kind.
Click the top-right corner of the Emitter in the System Overview Panel to jump to the parent Emitter.

One can hide particles from an Emitter by unchecking the checkbox in the lop-left of the emitter or in the Timeline Panel.
The Isolate button, the standing man, on each Emitter hides the particles from all the other emitters.

System can inherit from each other.
Inherited modules can be disabled.
New modules can be added.
Module parameter input values can be changed, both setting a new value and create a new binding.

[[2020-11-18_17:39:27]] [Niagara](./Niagara.md)  
[Niagara @ docs.unrealengine.com](URL: https://docs.unrealengine.com/en-US/Engine/Niagara/index.html)  

