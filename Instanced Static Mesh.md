2021-05-31_20:28:03

# Instanced Static Mesh

A Component that works much like a Static Mesh Component, but renders the assigned Static Mesh Asset multiple times.
Add elements to the Instances array for each new instance.
I have not been able to figure out how to move an instance in the viewport.
Instead I use the Transform property on the Instances array elements.
I think the intention is that the instances should be created programmatically.
Either from a Construction Script, or dynamically during gameplay.
Create a new instance by calling either Add Instance or Add Instance World Space.
