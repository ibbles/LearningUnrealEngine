2020-07-17_21:20:23

# Array

An Array in a Blueprint is a linear collection of elements all of the same type.
Indexing starts at zero.

To clear/empty an array, no not use en empty `SET` node (as is done with references), instead create a `Make Array` and assign that.

An array member can be a `UPROPERTY`. 
Such members will contain array operation (add/remove element) widets in the Details Panel.
The array can be sized using an enum, `int32 MyArray[EMyEnum::NumValue]`,
which will cause the GUI widget in the Details Panel to display the enum names for each element.
There is a UPROPERTY Meta Specififier that 

[[2020-03-09_21:43:36]] UPROPERTY
[[2020-07-02_15:45:39]] Enum