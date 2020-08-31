2020-08-22_16:58:51

# Data Table

Read only store of data.
Spreadsheet like.
Useful for external data that comes from people outside of the team.
Can be initialized from a CSV file.
Need a header line at the top of the file.
We must specify the structure of the data.
We do that with a Structure.
Create a new Structure by Content Browser > right-click > Blueprints > Structure.
The members of the structure should match (be exactly equal) the columns of the CSV, except for the first column.
The first column is used by Unreal Engine as an ID.
The rest of the members' names should match the column headers in the CSV.
The CSV is imported by Content Browser > Tool Bar > Import > Select CSV file.
Select DataTable and the name of the Structure in the settings window that opens.

We can use the same Structure for several Data Tables.

To read from a Data Table in a Blueprint use the Get Data Table Row node.
Select the Data Table to read in the node's drop down.
The second input should be one from the CSV's first column, the one that isn't matched by the structure's members.

Objects can store references to rows in a data table:
```c++
UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "Item",
          meta = (ShowOnlyInnerProperties, RowType = "LoadoutItem"))
FDataTableRowHandle LoadoutItem;
```
