2021-06-18_09:05:54

# Setting struct member in Blueprint Visual Script

The mental model of structs in Blueprints is an atomic unit, like `Vector` or `Rotator`.
When you make or assign a value you make and assign the entire struct value.
Sometimes you want to assign only a subset of the members of a struct.
Sometimes a struct represents more that just its `UPROPERTY` members so a full assignment would break things.
We can set individual members of a struct instance using a Set Members In *MyStruct* node.
When such a node is selected the Details Panel lists all the Blueprint-writable members along with a check box.
Check the check box and an input pin appears on the Set Members In *MyStruct* node.