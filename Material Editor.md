2020-08-24_10:55:42

# Material Editor

The Material Editor is used to create Render Materials.
A Render Material is a Visual Scripting Graph that is run per-vertex and/or per-pixel.
It produces a set of outputs that are used by the Shading Model.
The result of the computation is written to the input pin of the main material node.
It is which pin on the material node a node expression is connected to that determines if it's a per-vertex expression or per-pixel expression.
Which pins are active depend on the Shading Model that has been selected for the material.
The Shading Model is selected from the Details Panel when the main material node, or no node, is selected.

## Tool Bar

- Save: Save the material to disk.
- Browse: 
- Apply: Apply the recent changes to all users, i.e., meshes and material instances, of this material.
- Search: 

## Graph

This is where the material is defined, using a Visual Scripting Graph of expression nodes.
There are no execution nodes in a Material Graph. Or rather, the main material node is the sole execution node.

Hold `Alt` and click on a node pin to disconnect the wire from it.
Nodes can be duplicated with `Ctrl`+`w`.

## Viewport

Shows a preview of the material on one of a few types of meshes.
Switch between meshes using the buttons in the bottom right of the viewport.
We can preview on any mesh asset by selecting that asset in the Content Browser and the clicking the teapot in the material editor viewport.

Any (most?) node(s?) in the node graph can be selected as the preview node.
The output of that node will then be rendered in the preview viewport.
Mark a node for preview from its right-click menu.

[[2020-08-24_10:51:04]] [Shading models](./Shading%20models.md)  
[[2020-12-28_15:11:08]] [Material shading model inputs](./Material%20shading%20model%20inputs.md)  
[[2020-05-10_11:01:04]] [Materials](./Materials.md)  