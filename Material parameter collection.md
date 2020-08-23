2020-08-11_19:05:49

# Material Parameter Collection

A Material Parameter Collection is used when a Material has many parameters and we want to assign them in groups.
A single Material Parameter Collection can contain parameters for many Materials, so that en entire scene can change it's appearance/style by changing a single Material Parameter Collection.
A Material Parameter Collection is an asset that exists in the Content Browser.
Created by Content Browser > right-click > Create Advanced Asset > Materials & Textures > Material Parameter Collection.
They should be named with an `MPC_` prefix.
Contains two arrays, one named Scalar Parameters and one named Vector Parameters.
The parameters are the same as can be found in Material Instances.
In a Material Parameter Collection we can add new parameters by clicking the + next to one of the arrays.
Each parameter has a name and a default value.

Have not yet figured out how to do Material Parameter Collection Parameters. I want to create one Material that uses a Material Parameter Collection and then multiple Material Parameter Collections that each provide all the parameters used by the Material. Then I want to use the same material on many meshes but different meshes should use different versions of the Material Parameter Collection. Or alternatively, I want to use the same material and the same Material Parameter Collection for all/many objects in one level/map and the same material but another instance of the Material Parameter Collection in another level/map. The Material Parameter Collection used should define the look-and-feel/style of the level/map, but the material implementation should be the same everywhere.

A Material Parameter Collection can be dragged-dropped from the Content Browser into the Material graph.
Shows up as a Collection Param.
Can also be created with Graph > right-click > Collection Parameter.
Each Collection Param node in the Material graph corresponds to one of the parameters in the Material Parameter Collection.
Select which one each node should correspond to in the Details Panel, under Parameter Name.
Here we can also specify which collection the Collection Param node should bind to.
