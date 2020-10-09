2020-10-08_09:56:14

# Unit tests

Unit tests are part of the Automation Tool framework.

```
./UE4Editor
    /<path>/MyProject.uproject
    /Game/<path>/MyMap.umap
    [-Game]
    -NoSound
    -ExecCmds="Automation RunTests <Test ID string>"
    -Unattended
    -NullRHI
    -NoSplash
    -TestExit="Automation Test Queue Empty"
    -ReportOutputPath="/<path>/ue_tests_report"
    -log ABSLOG=/<path>/ue_tests.log
```

[[Automation tool]] [Automation tool](./Automation%20tool.md)