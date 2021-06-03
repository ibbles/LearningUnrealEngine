2021-05-29_07:58:52

# Import meshes

Import a mesh by right-click in the Content Browser in the folder you want to import into, select `Import to ...`.
Import a mesh by clicking the Import button in the top-left of the Content Browser.
Import a mesh by dragging it from a file explorer into the Content Browser.

If the source file has been changed it can be reimported to update the Unreal Engine asset with the new changes.
Either import again or right-click the asset in the Content Browser and select Reimport.
The Static Mesh asset contains the path to the source file.
Shown in Static Mesh Editor > Details Panel > Import Settings.
This property may be unset if the original import of the asset was made on a different machine.
Doing a reimport will store the new file system path in the asset.
(
Not sure if this will survive a trip through source control to another machine.
That would be sometimes bad and sometimes good.
)

Unreal Editor can be configured to automatically reimport any modified asset in selected folders.
Select directories to monitor in Top Menu Bar > Edit > Editor Preferences > General > Loading & Saving > Auto Reimport > Directories to Monitor.
Each monitored directory is mapped to a Content Browser folder where the assets will show up.
(
The tutorial at [Building Better Pipelines - Exporting and Importing 11:30 @ learn.unrealengine.com](https://learn.unrealengine.com/course/2436634/module/5372269) didn't work quite like that, but it was a bit confused so I'm not sure. It's unclear to me what the mapped folder really means.
)

## Full scene import

Used when the scene has already been built in the digital content creation (DCC) software.
As opposed to the individual assets that are placed in a scene in Unreal Editor.
Export from the DCC software as an FBX.
Import not as an asset, but instead with Top Menu Bar > File > Import Into Level.
Select a place within the Content folder to place the imported assets.
All the regular asset import options are available in the FBX Scene Import Options window that opens.
A Blueprint is created with all the imported assets.

Supports:
- Static Meshes.
- Skeletal Meshes.
- Animations.
- Morph targets.
- Materials, only diffuse and normal maps.
- Textures.
- Rigid bodies.
- Cameras, without animations.
- Lights.


## FBX

- Skeletal Mesh
Enable this if the mesh is a skeletal mesh.
- Import Animations.
Enable this if the model is a Skeletal Mesh that contains animations.
- Auto Generate Collision.  
Not sure what this does. What kind of collisions are generated? How many? How are they placed? 
- Generate Lightmap UVs.
Generate UVs on channel 1 containing lightmap-compatible texture coordinates by taking the coordinates from channel 0 and spreading them out so there are no overlaps and scaling them to fit within the 0..1 space. Not always great result.
- Transform Vertex to Absolute.
If disabled will cause collision meshes to have zeroed pivot points, i.e., all collision meshes will be centered around the model origin.
- Import Materials, Import Textures.
Recommended to disable these [Building Better Pipelines - Exporting and Importing 6:10 @ learn.unrealengine.com](https://learn.unrealengine.com/course/2436634/module/5372269). Materials and textures are often created and imported separately.


- Disable Mesh > Auto Generate Collision if the mesh contains collision.
- Disable Mesh > Generate Lightmap UVs if the mesh contains lightmap UVs.
- Set Mesh > Vertex Color Import to Replace if the mesh contains vertex colors.
- Enable Mesh > Import Mesh LODS if the mesh contains multiple LODs.
- Enable Material > Import Materials if the mesh contains materials.
- Enable Material > Import Textures if the mesh contains textures.


[[2020-11-10_08:30:07]] [Collision shapes](./Collision%20shapes.md)  


[[2020-05-08_22:05:51]] [Static Mesh](./Static%20Mesh.md)  
[[2020-12-26_21:50:52]] [Skeletal Mesh](./Skeletal%20Mesh.md)  
[[2021-05-29_10:13:01]] [FBX](./FBX.md)  
