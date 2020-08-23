2020-08-22_16:58:51

# Data Table

Read only store of data.
Spreadsheet like.
Useful for external data, that comes from people outside of the team.
Can be initialized from a CSV file.
Need a header line at the top.
We must specify the structure of the data.
We do that we a Structure.
Create a new Structure by Content Browser > right-click > Blueprints > Structure.
The members of the structure should match the columns of the CSV, expect for the first column.
The first column is used by Unreal Engine as an ID.
The rest of the members' names should match the column headers in the CSV.
The CSV is imported by Content Browser > Tool Bar > Import > Select CSV file.
Select DataTable and the name of the Structure in the settings window that opens.

To read from a Data Table in a Blueprint use the Get Data Table Row node.
Select the Data Table to read in the node's drop down.
The second input should be one from the CSV's first column, the one that isn't matched by the structure's members.
