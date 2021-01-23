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

[[2020-08-27_20:25:41]] [Automation tool](./Automation%20tool.md)  


## A Collection of links

**Why should you use Automation?**

> Every job has repetitive tasks and processes that can be automated. Those tasks can take up a significant amount of your time. Someone with only basic knowledge about scripting can build a script that might cut down the time to execute those tasks to a bare minimum. In the long run, this time saving accumulates into additional hours that can be used for more productive work. Learning how to automate things, therefore, is an invaluable skill. A skill that can be acquired in different, more specific sectors and then applied to other, more general ones.

-Tim Grossmann ([https://www.freecodecamp.org/news/becoming-an-unreal-automation-expert](https://www.freecodecamp.org/news/becoming-an-unreal-automation-expert)) 

Docs:
- [https://docs.unrealengine.com/en-US/TestingAndOptimization/Automation/index.html](https://docs.unrealengine.com/en-US/TestingAndOptimization/Automation/index.html) 
- [https://docs.unrealengine.com/en-US/TestingAndOptimization/Automation/Gauntlet/index.html](https://docs.unrealengine.com/en-US/TestingAndOptimization/Automation/Gauntlet/index.html) 

Videos:
- [https://www.youtube.com/watch?v=0BWQRZ8QW5E](https://www.youtube.com/watch?v=0BWQRZ8QW5E) : Automation for Performance Measurement 
- [https://www.youtube.com/watch?v=uQVBCJiHedg](https://www.youtube.com/watch?v=uQVBCJiHedg) : Postmortem on some undisclosed AAA game by Square Enix

Community:
-  [https://blog.squareys.de/ue4-automation-testing/](https://blog.squareys.de/ue4-automation-testing/) 
-  [https://mercuna.com/creating-functional-tests-in-unreal-engine-4/](https://mercuna.com/creating-functional-tests-in-unreal-engine-4/) 
-  [https://saracengames.com/?p=126](https://saracengames.com/?p=126) 
-  [https://benui.ca/unreal/unreal-testing-tdd/](https://benui.ca/unreal/unreal-testing-tdd/) 
-  [https://kobiton.com/automation-testing/an-introduction-to-automated-testing-for-an-unreal-engine-project/](https://kobiton.com/automation-testing/an-introduction-to-automated-testing-for-an-unreal-engine-project/) 
-  
-  Sea of Thieves: 
-  [https://www.youtube.com/watch?v=Bu4YV4be6IE](https://www.youtube.com/watch?v=Bu4YV4be6IE) [https://ubm-twvideo01.s3.amazonaws.com/o1/vault/gdc2019/presentations/Masella\_Robert\_AutomatedTestingOf.pdf](https://ubm-twvideo01.s3.amazonaws.com/o1/vault/gdc2019/presentations/Masella_Robert_AutomatedTestingOf.pdf)
-  [https://www.youtube.com/watch?v=KmaGxprTUfI&ab_channel=UnrealEngine](https://www.youtube.com/watch?v=KmaGxprTUfI&ab_channel=UnrealEngine) 

CI: 
- [https://patricevignola.com/post/automation-jenkins-unreal](https://patricevignola.com/post/automation-jenkins-unreal)
- [https://www.ue4community.wiki/jenkins-example-windows-installation-perforce-z98w4map](https://www.ue4community.wiki/jenkins-example-windows-installation-perforce-z98w4map)
- [https://www.rare.co.uk/news/tech-blog-continuous-delivery-part1](https://www.rare.co.uk/news/tech-blog-continuous-delivery-part1)


