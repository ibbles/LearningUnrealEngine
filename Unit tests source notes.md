2020-10-22_07:51:18

# Notation

Each chapter, except for this one and the Summary, corresponds to a source. Each
source has an URL, an author, and optinally an Unreal Engine version for which
the source was written. Each line of text that state a fact from the source is a
regular line. Each line of text that is a comment from me is prefixed with >.

> This is a comment from me.

All example names for classes, functions, plugins, etc, are prefixed with `My`.

# Summary

Tests can be in both C++ and Blueprint.
This discussion is mostly about C++.

C++ tests should be in their own module or plugin.
They should be in the `Private/Tests` subdirectory of the module's `Source` directory.
`Plugins/MyPlugin/Source/MyPluginTest/Private/Tests`
Each filename should end with `Test.cpp`.
`MyClassTest.cpp`, `MyOtherClassTest.cpp`, etc.
Tests have hierarchical names, `.`-separated.
Each `Test.cpp`-file can contain multiple tests.
For example: `MyPlugin.MyUtilities.MyUtilityFunction`.
A test can be either simple or complex.
Simple means that it runs once and return true for pass and false for fail.
Complex means that it is run multiple times with different input.
The same return value semantics.
A separate pre-function determine the set of inputs.
Tests are declared with macros.
`IMPLEMENT_SIMPLE_AUTOMATION_TEST` and `IMPLEMENT_COMPLEX_AUTOMATION_TEST`.
Takes three parameters: `TClass`, `PrettyName`, `TFlags`.
Example:
```c++
IMPLEMENT_SIMPLE_AUTOMATION_TEST(
    FMyGameClassTest, "MyGame.SomeCategory.MyGameClass",
    EAutomationTestFlags::EditorContext | EAutomationTestFlags::EngineFilter)
```
The `EAutomationTestFlags` control if/when the test should be run.
Not sure what the best-practices are.
`EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter` seems to work.
The actual test function is called `RunTest`.
Example:
```c++
bool FMyGameClassTest::RunTest(const FString& Parameters)
{
    // Make the test pass by returning true, or fail by returning false.
    return true;
}
```
In a complex test, `GetTests` is used to instantiate `RunTest` descriptions.
Each instantiation has a name and a command.
The name is appended to the name of the complext test. I think.
The command is passed as an argument to the `RunTest` function.
Example complex text:
```c++
IMPLEMENT_COMPLEX_AUTOMATION_TEST(
    FMyComplexTest, "MyGame.MyComplex", 
    EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)

void FMyComplexTest::GetTests(
    TArray<FString>& OutBeautifiedNames, TArray<FString>& OutTestCommands) const
{
    OutBeautifiedNames.Add("SubTest1");
    OutTestCommands.Add("1");

    OutBeautifiedNames.Add("SubTest2");
    OutTestCommands.Add("2");
}

bool FMyComplexTest::RunTest(const FString& Parameters)
{
    FString Id = Parameters;

    // Id is either "1" or "2".
    // Use it to test something.

    return true; // Or false.
}
```
Actual testing can be done with `TestEqual`, `TestLessThan` and similar helper functions.
Cases that should print an error message are tested with `AddExpcetedError` in `RunTest`.
Latent commands are scheduled for later execution, in a later frame.
They have an `Update` method that is called every tick until `true` is returned.
I think the latent commands are in a queue, so the next won't run until the current is finished.
Used for asynchronous events such as map loading or just to wait for a bit.
Create with `DEFINE_LATENT_AUTOMATION_COMMAND` and a member function definition.
Example:
```c++
DEFINE_LATENT_AUTOMATION_COMMAND(FMyLatentCommand);

bool FMyLatentCommand::Update()
{
    return /* Some event has happened, or some criterion is true. */
}
```
Can take parameters.
The parameter becomes a class member variable.
```c++
DEFINE_LATENT_AUTOMATION_COMMAND_ONE_PARAMETER(FMyCommand, <Parameter type>, <Parameter name>);
bool FMyCommand::Update()
{
    // Use <Parameter name>, now a class member variable, to determine wheter to return true or false.
}
```
Pass the `this` `FGameTest*` get access to the `TestEqual` and so on helper functions.
Used with `ADD_LATENT_AUTOMATION_COMMAND` from within `RunTest`.
```c++
ADD_LATENT_AUTOMATION_COMMAND(FMyCommand(this));
```
The `RunTest` function does not wait for the latent command to finish.
Everything that must wait on a Latent Command must also be a Latent command.

Blueprint tests:
Create a map with name prefix `FTEST_`.
Create a `FunctionalTest` Blueprint.  TODO: Check this, the YouTube video.

Test plugins must be enabled before the tests can be run.
Top Menu Bar > Edit > Plugins.
Restart Unreal Enditor after enabling or disabling plugins.
Run tests from the Session Frontent, Automation tab.
Top Menu Bar > Window > Test Automation.
At least one plugin with tests must be enabled for this to show up.
There is also a stand-alone binary for the Session Frontent, called the Unreal Frontend.

Tests are run from the command line with the following command:
```
./UE4Editor
<Path to project file>
<Asset path to initial map, eg '/Game/Levels/MyLevel'>
-NoSound
[-Game]
-ExecCmds="Automation RunTests <pretty-name/path for test>"
-Unattended
-NullRHI
-NoSplash
-TestExit="Automation Test Queue Empty"
-ReportOutputPath="<Test output directory>"
-log
ABSLOG=<Log output file>
```
Unclear on when/if `-Game` should be passed. Not sure what that does.
Starts the game, I guess.
I used to be able to run tests with `-Game` passed, but with Unreal Engine 4.25 that doesn't work anymore.
The tests are never run an Unreal Engine stops at `Resizing viewport due to setres change, 1920 x 1080`.

I have three cases:
- From command line with `-Game`.
- From command line without `-Game`.
- From Unreal Editor Session Frontend.
Without `-Game` I can't run world tests because the world isn't a `Game` world.
The world is an `Editor` world.
`FLoadGameMapCommand` asserts when it's an `Editor` world.
With `-Game` I can run my world tests just fine. (Not anymore, possibly after upgrade to 4.25.)
From the Unreal Editor Session Frontent I cannot run my world tests, because it's an `Editor` world.


Some suggest passing `-NoPause` as well. Manual says `Close the log window automatically on exit`.
The map passed is the map that is loaded initially.
Some suggest passing `-Messaging` as well. Not documented at [CommandLineArguments@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/Basics/CommandLineArguments/index.html).
https://answers.unrealengine.com/questions/303577/automation-testing-on-binary-engine-is-broken.html
Is it the world in which the tests are run? Can I query for world contents?

The result of a run is a JSON file with an entry for each test.
The process exit status is `EXIT_SUCCESS` even is some tests fail.
The exit status is for the test runner itself.
The `;Quit` part of `-ExecCmds` (now removed from these notes) and `-TestExit` do the same thing.
The former handles the case where no tests were found, so `-TextExit` never activates.
However, `;Quit` leads raises `CriticalError` and an non-zero exit code from the process.
I way want to run without it... maybe. Not sure.

I had hoped to be able to run multiple test by just listing them one after another, but that didn't work.
It thought the entire list was a single test name.
I tried with ',' between, but that didn't work either.
I tried with `;RunTests <pretty-name>` after the first, but then it didn't run
the first test and ran the second one twice.
I tried with `;Automation RunTests <pretty-name>` after the first, but gives
`Incorrect automation command syntax!` and then it runs only the first test.
Trying a space-separated list with `"` around each test name, but now I get
`Found 0 Automation Tests, based on ''\`. Where did the empty string come from?
I give up...

# Automation System Overview

URL: https://docs.unrealengine.com/en-US/Programming/Automation/index.html
Author: Epic Games
Unreal Engine Version 4.17


The automation system is used for unit testing, feature testing, and content stress testing.
Built on top of the Functional Testing Framework.
> Searching for "Functional Testing Framework" on docs.unrealengine.com takes me to
> https://docs.unrealengine.com/en-US/Programming/Automation/FunctionalTesting/index.html
> which is just a front-page type page, with "Get STarted with UE4", "Unreal Editor Manual"
> and stuff like that. Basically a 404 page.

The Functional Testing Framework does gameplay level testing through automated tests.
There are five types of tests:
- `Unit`: API level verification tests. See `TimespanTest.cpp` or `DateTimeTest.cpp`
  for examples of these.
- `Feature`: System-level tests that verify such things as PIE, in-game stats,
  and changing resolution. See `EditorAutomationTests.cpp` or
  `EngineAutomationTests.cpp` for examples of these.
- `Smoke`: Smoke tests are just considered a speed promise by the
  implementer. They are intended to be fast so they can run everytime the
  Editor, game, or commandlet starts. They are also selected default in the UI .
- `Content Stress`: More thorough testing of a particular system to avoid
  crashes, such as loading all maps or loading and compiling all Blueprints. See
  `EditorAutomationTests.cpp` or `EngineAutomationTests.cpp` for examples of these.
- `Screenshot Comparison`: This enables your QA testing to quickly compare
screenshots to identify potential rendering issues between versions or builds.

> At this stage, I belive we're mostly interested in the Unit and Feature type
tests.
> Possibly also Content Stress once we have built a few test levels.


## Automation Tests moved to Plugins

Built-in Engine and Editor tests have been moved to plugins.
Can be included in packaged builds when compiling.
Plugins can store content separate from the Engine Content folder.
Engine and Editor tests are stored in different plugins depending on the type:
- `Unit`: In the same module as the tested code.
- `Project Agnostic Runtime Tests`: RuntimeTests Plugin.
- `Project Agnostic Editor Tests`: EditorTests Plugin.
- `Functional Tests`: EngineTest Game folder.

> Not sure where all of these plugins are, and what the `EngineTest Game folder` is.
> Not sure how project-specific tests should be handled.
> Not sure how plugin tests should be handled.

The Plugins Browser list, under Testing, may list additional test plugins.


## Enabling Automation Test Plugins

Test plugins are enabled in the Plugins list.
Top Menu Bar > Edit > Plugins > Built-in > Testing.


## Test Design Guidelines

Don't assume the state of the game or editor, tests can be run out or order or parallel across machines.
Leave the state of the files on disk the way you found them.
Assume the test was left in a bad state the last time it was run.


## Running Automation Tests

Open any project.
Enable the plugin that contains the tests to run: Top Menu Bar > Edit > Plugins > Built-in > Testing.
Restart Unreal Editor if plugins were enabled or disabled.
Open test window: Top Menu Bar > Window > Test Automation.
This entry only exists if a module with tests was found during startup.
I belive it can also be found in Session Frontend.
The Automation tab holds a tree of checkboxed names according to the hierarchical PrettyName.
Check the tests to run and then click Start Tests in the Tool Bar.
Color-coded boxes to the right shows the test result as the tests finish.


## Essentials

There is something called Unreal Message Bus.

> I don't know what that is.
> Not finding much documentation on docs.unrealengine.com, except for the C++ API reference.




# Automation System User Guide

URL: https://docs.unrealengine.com/en-US/Programming/Automation/UserGuide/index.html
Author: Epic Games
Unreal Engine Version: 4.17

The Automation tab is part of the Session/Unreal Frontent.
This makes it possible to run tests on a remote machine.
It can be accessed either from within Unreal Editor or stand-alone:
- `Unreal Editor`: Top Menu Bar > Window > Developer Tools > Session Frontend.
- `Stand-alone`: `Engine/Binaries/<OS>/UnrealFrontent<exe-suffix>`.


## Enabling Plugins

This step is not required when using the Unreal Frontend.
Automation Tests are placed in plugins.
Plugins must be enabled.
Top Menu Bar > Edit > Plugins > Built-in/Project > Testing.
Some plugins may come with the tests built into the plugin module directly, and thus won't have a separate Automation plugin under Testing.
Enable the test plugins you wish to use.
Restart the editor.


## User Interface

The Automation Testing UI is in the Automation tab of the Session Frontend.
The Frontend must be connected to a session for anything to be shown.
Sessions are selected from the list on the left.
`This Application` is a special session that referse to the current Unreal Editor instance.


## Session Browser

The session list is called the Sesson Browser.
From here we can connect to specific instances of the editor.
Selecting a session will populate the Automation tab with the automation tests available from that session.


## Toolbar

The Automation toolbar contains a number of buttons:
- `Start Tests`: Start the currently selected tests. A number on the button shows the number of tests selected.
- `Run Level Test`: If the currently loaded level is a test map, you can click this button to select the tests and run it immediately.
- `Refresh Tests`: If the currently loaded level is a test map, you can click this button to select the tests and run it immediately.
> Don't know what would cause a test to be added. The editor must be restarted when the C++ code is recompiled.
- `Find Workers`: This will find local workers that can be used to perform the tests.
- `Errors`: Toggles a filter for the Test window that displays any tests that ran into an error while attempting to complete.
- `Warnings`: Toggles a filter for the Test window that displays any tests that ran into a warning while attempting to complete.
- `Dev Content`: When enabled, developer directories will be included for automation tests.
- `Device Groups`: Enables you to group the tests based on a series of options, such as the machine name, platform, operating system version, and much more.
- `Preset`: Enables you to add your own presets for automation tests with the selected tests and settings so that you can use them again at a later date.


## Test Window and Results

The Automation Test Results panel shows information about the tests that have been run.
It displayes a time line with all the tests run on each worker machine.
Tests can be displayed either with name or time to complete.
Selecting a failed test in the test list will show the error message in the Results panel.


## Export

Test results can be exported to a CSV file.
Select one or more tests and click the Export button in the lower right corner.
Must select a test, i.e. a leaf node in the test hierarly. Doesn't work with internal nodes.


## Copy

In addition to export, test results can be placed in the clipboard.
Same rules and steps apply.




# Automation Technical Guide

URL: https://docs.unrealengine.com/en-US/Programming/Automation/TechnicalGuide/index.html
Author: Epic Games
Unreal Engine Version: 4.17


## Automation Testing

Automation testing is the lowest level of the testing types available in Unreal Engine.
It is best suited for low-level tests of the core functionality of the engine.

> Can plugins be tested in this way as well?

The system is not visible to Blueprints or the Reflection System.

> Unclear about the opposite direction, i.e., can I write an Automation Test that tests a Blueprint?
> Can Automation Testing tests test functionality of classes derived from UObject?

The tests are built in code and can be run from the terminal.

> This is what we want. Part of what we want, at least.

There are two types of Automation Tests: Simple and Complex.
Both are implemented as classes deriving from `FAutomationTestBase`.


## Create a New Automation Test

Tests are declared by macros.
Tests are implemented by overriding virtual functions.
Simple Tests use the `IMPLEMENT_SIMPLE_AUTOMATION_TEST` macro.
Complex Tests use the `IMPLEMENT_COMPLEX_AUTOMATION_TEST` macro.
Both macros have the following three parameters:
- `TClass` Desired name of the test. A class with this name is declared.
- `PrettyName` Dot-separated hierarchical name of the test.
- `TFlags` A Combination of EAutomationTestFlags controlling requirements and behaviors.
For each declared class on must implement the following methods:
- `RunTest(Parameters)` The actual test. Return `true` for pass and `false` for failure.
    - `Parameters` Can be parsed or passed through to other functions. (??)
- `GetTests(OutBeautifiedNames, OutTestCommands)` For Complex Tests only.
    - `OutBeautifiedNames`: Array of strings holding the names for each individual Test.
    - `OutTestCommands`: Array of strings holding the parameters to each individual Test.

> I guess I will learn more about the `TFlags` elsewhere.


### Source File Locations

Tests should be put in the `Private/Tests` directory of the module.
When testing tests for a class named `MyClass` the test file should be `MyClassTest.cpp`.


## Minimal Example

```c++
IMPLEMENT_SIMPLE_AUTOMATION_TEST(
    FMyFunctionTest, "TestGroup.TestSubgroup.MyClass.MyFunction",
    EAutomationTestFlags::EditorContext | EAutomationTestFlags::EngineFilter)

bool FMyFunctionTest::RunTest(const FString& Parameters)
{
    // Create an instance of [FUA]MyClass, call MyFunction, and verify the result.
    // Make the test pass by returning true, or fail by returning false.
    return true;
}
```

> Following the naming convetion, the above would be a test for the imaginary
> class `MyClass` and it would be stored in the file `MyClassTest.cpp`.
> I think the `FString Parameters` is something that is passed on the command line,
> not something that is really part of the normal test. Not sure where it comes from.
> For complex tests it holds the command specified in `GetTests`.


## Simple Tests

Describe single atomic unit- or feature tests.
Example for `SetRes`:

```c++
IMPLEMENT_SIMPLE_AUTOMATION_TEST(FSetResTest, "Windows.SetResolution", ATF_Game)

bool FSetResTest::RunTest(const FString& Parameters)
{
    FString MapName = TEXT("AutomationTest");
    FEngineAutomationTestUtilities::LoadMap(MapName);

    int32 ResX = GSystemSettings.ResX;
    int32 ResY = GSystemSettings.ResY;
    FString RestoreResolutionString = FString::Printf(TEXT("setres %dx%d"), ResX, ResY);

    ADD_LATENT_AUTOMATION_COMMAND(FEngineWaitLatentCommand(2.0f));
    ADD_LATENT_AUTOMATION_COMMAND(FExecStringLatentCommand(TEXT("setres 640x480")));
    ADD_LATENT_AUTOMATION_COMMAND(FEngineWaitLatentCommand(2.0f));
    ADD_LATENT_AUTOMATION_COMMAND(FExecStringLatentCommand(RestoreResolutionString));

    return true;
}
```

> `FEngineAutomationTestUtilities::LoadMap` seems important.
> I wonder if "AutomationTest" is a special map name.
> Not sure what `ADD_LATENT_AUTOMATION_COMMAND` is, but it seems important.
> An odd test, that checks nothing and always return `true`.


## Complex Tests

Used to run the same code on a number of inputs.
Often content stress tests.
Must provide both `RunTest` and `GetTests` functions.
For example: loading all maps, compiling all Blueprints.
Example that loads all maps:

```c++
IMPLEMENT_COMPLEX_AUTOMATION_TEST(FLoadAllMapsInGameTest, "Maps.LoadAllInGame", ATF_Game)

void FLoadAllMapsInGameTest::GetTests(
    TArray<FString>& OutBeautifiedNames, TArray<FString>& OutTestCommands) const
{
    FEngineAutomationTestUtilities Utils;
    TArray<FString> FileList;
    FileList = GPackageFileCache->GetPackageFileList();

    // Iterate over all files, adding the ones with the map extension..
    for (int32 FileIndex = 0; FileIndex < FileList.Num(); FileIndex++)
    {
        const FString& Filename = FileList[FileIndex];

        // Disregard filenames that don't have the map extension if we're in MAPSONLY mode.
        if (FPaths::GetExtension(Filename, true) == FPackageName::GetMapPackageExtension())
        {
            if (!Utils.ShouldExcludeDueToPath(Filename))
            {
                OutBeautifiedNames.Add(FPaths::GetBaseFilename(Filename));
                OutTestCommands.Add(Filename);
            }
        }
    }
}

bool FLoadAllMapsInGameTest::RunTest(const FString& Parameters)
{
    FString MapName = Parameters;

    FEngineAutomationTestUtilities::LoadMap(MapName);
    ADD_LATENT_AUTOMATION_COMMAND(FEnqueuePerformanceCaptureCommands());

    return true;
}
```

> The `GetTests` function finds the names of all the maps that should be tested.
> The `RunTest` function is called with each map name that `GetTests` returned.
> For each map `LoadMap` is called and then a performance capture command is added.
> This test also always return `true`.

The `GetTests` is the intended way to test several data points using the same code.


## Latent commands

Latent commands are run in a later frame.
Latent Actions are created with the `DEFINE_LATENT_AUTOMATION_COMMAND` macro.
The macro takes a `CommandName` parameter.
The `CommandName` becomes the name of a class stamped out by the macro.
The stamped out class has an `Update` function that must be defined.
Example:

```c++
DEFINE_LATENT_AUTOMATION_COMMAND(FNUTWaitForUnitTests);

bool FNUTWaitForUnitTests::Update()
{
    return GUnitTestManager == NULL || !GUnitTestManager->IsRunningUnitTests();
}
```

There is also a version of the macro that creates a function that takes a parameter.
Parameters to the macro define the type and name of the function parameter.
Example:

```c++
DEFINE_LATENT_AUTOMATION_COMMAND_ONE_PARAMETER(
    FConnectLatentCommand,
    SourceControlAutomationCommon::FAsyncCommandHelper, AsyncHelper);

bool FConnectLatentCommand::Update()
{
    // Attempt a login and wait for the result.
    if(!AsyncHelper.IsDispatched())
    {
        if(ISourceControlModule::Get().GetProvider().Login(
            FString(), EConcurrency::Asynchronous, FSourceControlOperationComplete::CreateRaw(
                &AsyncHelper,
                &SourceControlAutomationCommon::FAsyncCommandHelper::SourceControlOperationComplete)) != ECommandResult::Succeeded)
        {
            return false;
        }
        AsyncHelper.SetDispatched();
    }

    return AsyncHelper.IsDone();
}
```

The return value from the `Update` function has the following semantics:
- `false`: Stop executing the Automation Test and try again next frame.
- `true`: The Latent Command is considered complete.


Latent Commands are queued in the `RunTest` function using the `ADD_LATENT_AUTOMATION_COMMAND` macro.
Create a new intance of the Latent command as the macro's first parameter.
If the Latent Command takes a parameter then pass that to the command's constructor.
Example:

```c++
ADD_LATENT_AUTOMATION_COMMAND(FNUTWaitForUnitTests());
ADD_LATENT_AUTOMATION_COMMAND(FConnectLatentCommand(SourceControlAutomationCommon::FAsyncCommandHelper()));
```

> Are latent commands run immediately (`RunTest` acting as a coroutine) with
> Unreal Engine doing frame stepping in-between the yields and resuming `RunTest`?
> Or is the whole `RunTest` function executed first and then stepping starts?
> It's the latter. `RunTest` creates a queue of latent commands and returns before they start executing.
> The Automation framework will keep the current test alive as long as there are Latent Commands in the queue.
> Any errors reported from a Latent Command, with `TestEqual` and such, are attributed to the test that queued the Latent Command.

Note about map loading. In the Editor, map loading happens immediately.
In a game, map loading happens on the next frame.
Thus a Latent Command must be used to load a map to ensure consistent behavior.


> This source says nothing about how to run the tests. Surprising.


> My summary:
> Unit tests are written in C++.
> They can be either one-off functions that return true for passed and false for failure.
> A complex test is a combination of a simple test and a test input generator function.
> Tests are run from the command line, either from Unreal Editor or the operating system.
> Tests can use Latent Commands, which is a callback-type function that is run between frames.




# EAutomationTestFlags::Type

URL: https://docs.unrealengine.com/en-US/API/Runtime/Core/Misc/EAutomationTestFlags__Type/index.html
Author: Epic Games.
Unreal Engine Version: Unclear. Page fetched when 4.25 was current.

The `EAutomationTestFlags` are split into a few categories:
- `Context`: Where to run the test.
  - `EditorContext`, `ClientContext`, `ServerContext`, `CommandletContext`.
- `Priority`: How to visualize a failed test, I assume. Perhaps also run order.
  - `CriticalPriority`, `HighPriority`, `MediumPriority`, `LowPriority`
- `Filter`: The "type" of the test.
  - `SmokeFilter`, `EngineFilter`, `ProductFilter`, `PerfFilter`, `StressFilter`, `NegativeFilter`.
- `Mask`: One mask per category. I thought these were used to extract the bits reserved for each category,
  but `DateTimeTest.cpp` uses `ApplicationContextMask` directly which goes against that assumption. Perhaps
  that just means that the test should be included in all contexts.
  - `ApplicationContextMask`, `FeatureMask`, `PriorityMask`, `FilterMask`.
- `Other`: Things not in a particular category.
  - `NonNullRHI`, `RequiresUser`, `Disabled`, `HighPriorityAndAbove`, `MediumPriorityAndAbove`.




# Automation Spec

URL: https://docs.unrealengine.com/en-US/Programming/Automation/AutomationSpec/index.html
Author: Epic Games
Unreal Engine Version: 4.22

A new type of Automation test.
Used for tests following the Behavior Driven Design (BDD) methodology.
Reasons for creating Specs:
- Self-documenting.
- Fluent and DRYer.
- Better suited fro threaded or latent test code.
- Can be used for many flavors of tests: functional, integration, unit.

## How to set up a spec

Two methods.
`DEFINE_SPEC` macro.
Takes the same parameters as `IMPLEMENT_SIMPLE_AUTOMATION_TEST`.
Example:
```c++
DEFINE_SPEC(
    MyCustomSpec,
    "MyGame.MyCustomSpec",
    EAutomationTestFlags::ProductFilter | EAutomationTestFlags::ApplicationContextMask)
void MyCustomSpec::Define()
{
    /// @todo Write my expectations here.
}
```
The other method uses the `BEGIN_DEFINE_SPEC` and `END_DEFINE_SPEC` macros.
Allows the addition of member variables.
Example:
```c++
BEGIN_DEFINE_SPEC(
        MyCustomSpec,
        "MyGame.MuCustomSpec",
        EAutomationTestFlags::ProductFilter | EAutomationTestFlags::ApplicationContextMask)
    TSharedPtr<FMyAwesomeClass> AwesomeClass;
END_DEFINE_SPEC(MyCustomSpec)

void MyCustomSpec::Define()
{
    \\\\ @todo Write my expectations here.
}
```
The source file should be named `.spec.cpp`.
The source file should not have `Test` in it.
For example, the class `FSphere` should have the files
- `Sphere.h`: Definition of the `FSphere` class.
- `Sphere.cpp`: Definitions of the non-inline member functions.
- `Sphere.spec.cpp`: Automation tests implemented using the Spec framework.
- `SphereTest.cpp`: Automation tests implemented using the Simple/Complex framework.
The `spec` one and the `Test` one fill the same purpose so only one might be sufficient.


## How to define your expectations

Behavior Driven Design (BDD) tests expectations of a public API.
Instead of a specific implementation.

> What's the difference? All tests should be through the public API.

Makes tests less brittle and easier to maintain.

> How?

Makes tests more likely to work with new implementations with the same API.

> Does that ever happen?

A Spec contains two primary functions: `Describe()` and `It()`.


## Describe

`Describe()` is used to scope complicated expectations.

> I don't know what that means.

It interacts with supporting functions such as `BeforeEach()` and `AfterEach()`.
```
void Describe(const FString& Description, TFunction<void()> DoWork)
```
The string desribe the scope of the expectations.
The function define the expectations.
`Describe()`s can be nested.
`Describe()` is not a test and is not executed during test runs.
`Describe()`s are only executed once when defining the expectations within a Spec.


## It

`It()` defines an actual expectation for a Spec.
Is called from `Define()` or `Describe()`.
Contains one or more asserts.
Can, but shouldn't, do the final bits of setup for the scenario.
Start the `It()` description with the word "should", implying "it should".


## Defining a basic expectation

Example expectation:
```c++
BEGIN_DEFINE_SPEC(
        MyCustomSpec,
        "MyGame.MyCustomClass",
        EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)
    TSharedPtr<FMyCustomClass> CustomClass;
END_DEFINE_SPEC(MyCustomSpec)

void MyCustomSpec::Define()
{
    Describe("Execute(), [this]()
    {
        It("should return true when successful", [this]()
        {
            TestTrue("Execute", CustomClass->Execute());
        });

        It("should return false when unsuccessful", [this]()
        {
            TestFalse("Execute", CustomClass->Execute());
        });
    });
}
```
The fluent API and the large number of descriptions/names makes the tests self-documenting.
They should read like sentences.
"Execute() should return true when successful".
"Execute() should return false when unsuccessful".
A real-world example:
```
Automation
  Driver
    Element
      Click
        should simulate a cursor move and click and wait for the element to become interactable
        should simulate a cursor move and click and wait for the element to become visible
        should simulate a cursor move and click on a valid tagged widget
        should simulate a cursor move and click on multiple valid tagged widgets
        should simulate a cursor move and click on multiple valid tagged widgets, in equence
```
Here, `Driver`, `Element`, and `Click` are each `Describe()` calls.
The `should` messages are defined by `It()` calls.
Each `It()` is an individual test.
Each `It()` can be executed in isolation.
The large amount of built-in description makes it easy for the one reading a failure test report to know what's going on.


## How a Spec expectation translates to a test

A Spec's root `Define()` is executed once.
Non-`Describe()` lambdas are collected.
When `Define()` finishes the collected lambdas are turned into an array of Latent Commands for each `It()`.
Thus, each `BeforeEach()`, `It()`, and `AfterEach()` lambda becomes a chain of execution for that test.
When a test is to be run, that test's array of Latent Commands are queued.


## Additional Features

The Spec test type provides features that removes the need to use Latent Commands directly.
List of features:
- BeforeEach
- AfterEach
- AsyncExecution
- Latent Completion
- Parameterized Tests
- Redefine
- Disabling Tests


### BeforeEach and AfterEach

`BeforeEach()` registers a lambda to be run before the subsequent `It()`.
`AfterEach()` register a lambda to be run after each `It()`.
> It's unclear to me what significance order in the `Describe()` has here.
> Do the `BeforeEach()`/`AfterEach()` apply to all `It()` in the `Descripe()`?
> Order has no impact. See below.

Each test consist of a single `It()`, along with the `BeforeEach()` and `EfterEach()` that apply to it.
Example:
```c++
BEGIN_DEFINE_SPEC(
        AutomationSpec,
        "System.Automation.Spec",
        EAutomationTestFlags::SmokeFilter | EAutomationTestFlags::ApplicationContextMask)
    FString RunOrder;
END_DEFINE_SPEC(AutomationSpec)

void AutomationSpec::Define()
{
    Describe("A spec using BeforeEach and AfterEach", [this]()
    {
        BeforeEach([this]()
        {
            RunOrder = TEXT("A");
        });

        It("will run code before each spec in the Describe and after each spec in the Describe", [this]()
        {
            TestEqual("RunOrder", RunOrder, TEXT("A"));
        });

        AfterEach([this]()
        {
            RunOrder += TEXT("Z");
            TestEqual("RunOrder", RunOrder, TEXT("AZ"));
        });
    });
}
```
The result is the same regardless of the order of `BeforeEach()`, `It()`, and `AfterEach()`.
The example does a test in an `AfterEach()`. Don't do this. Only test in `It()`s.
`AfterEach()` should only be for cleanup.
If there are multiple `BeforeEach()` or `AfterEach()`, then they will be called in the order they are defined.
`BeforeEach()` and `AfterEach()` apply to the `It()`s in the `Describe()` scope they are in.
> I assume it applies transitively into nested `Describe()` scopes.
> Yes, according to my reading of the "complicated example".


### AsyncExecution

`BeforeEach()`/`It()`/`AfterEach()` all take an optional `EAsyncExecution` parameter.
It controls how that block should be executed.
Example:
```c++
BeforeEach(EAsyncExecution::TaskGraph, [this](){};
It("should...", EAsyncExecution::ThreadPool, [this](){};
AfterEach(EAsyncExecution::Thread, [this](){};
```
Lambdas enqueued with `TaskGraph` will run in the task graph.
Lambdas enqueued with `ThreadPool` will run in one of the threads in the thread pool.
Lamdas enqueued with `Thread` will run in a thread started for that task only.
The order is guaranteed regardless of the parameter.
> Not sure what these are for. When would it matter? What is the default? Not thread, I hope.

Useful when testing thread sensitive scenarios.
Can be combined with the Latent Completion feature.


### Latent Completion

There are `Latent` versions of `BeforeEach()`, `It()`, and `AfterEach()`.
`LatentBeforeEach()`, `LatentIt()`, `LatentAfterEach()`.
Identical to the non-latent variant, except for an additional `Done` delegate parameter to the lambda.
Execution will not continue to the next lambda in the chain until the current one invokes the Done delegate.
Example:
```c++
LatentIt("should return available items", [this](const FDoneDelegate& Done)
{
    BackendService->QueryItems(this, &FMyCustomSpec::HandleQueryItemComplete, Done);
});

void FMuCustomSpec::HandleQueryItemComplete(const TArray<FItem>& Items, FDoneDelegate Done) /// > Not ref?
{
    TestEqual("Items.Num() == 5", Items.Num(), 5);
    Done.Execute()
}
```
The `Done` delegate can be passed on to other callbacks.
That makes it accessible to the code that will be executed at some future frame.
The Latent Completion feature can be combined with the AsyncExecution feature.


### Parameterized Tests

Used to create tests in a data-driven way.
Possibly by dynamically by reading files or a file system directory.
It can also be a way to reduce test code duplication.
Parameterized tests are created by calling `It()` in a loop, or multiple times
some other way, and in the lambda capture a new value each time. A unique description
must also be generated.
Example:
```c++
Describe("Basic Math", [this]()
{
    for (int32 Index = 0; Index < 5; Index++)
    {
        It(FString::Printf(TEXT("should resolve %d + %d = %d", Index, 2, Index + 2), [this, Index]()
        {
            TestEqual(FString::Printf(TEXT("%d + %d = %d"), Index, 2), Index + 2, Index + 2);
        }
```
There is a trade-off between creating many separate tests and testing several things in the same test.
Too many tests leads to test bloat, while doing too many things in a single test
makes it more difficult to pinpoint what exactly went wrong.
Testing each thing in isolation may also make reproduction easier.


## Redefine

Code blocks can be disabled by putting an `x` before its `Describe()`, `BeforeEach()`, `It()`, and `AfterEach()`.
The Spec framework provide `xDescribe()`, `xBeforeEach()`, `xIt()`, and `xAfterEach()`
with the same interface but with empty implementations.


## Mature examples

See `Engine/Source/Developer/AutomationDriver/Private/Specs/AutomaitonDriver.spec.cpp`.


### Observations from AutomationDrive.spec.cpp

Have macros that expand
- `ANOTHER_MACRO(TEXT(#expression), expression, true)`
- `ANOTHER_MACRO(TEXT(#expression), expression, false)`
for simple expect true/false tests.

They use `ProductFilter | ApplicationContextMask`.
They pass `EAsyncExecution::ThreadPool` in several places.

I think Spec tests can use the same test functions as the regular/old tests.
That is, we get a class that inherit from \`FAutomationTestBase\`.




# Test maps

I don't know how to create these, but I would like to know.
The Automation tab in the Session Frontend has a button labeled `Run Level Test`.
Is it related to the `FTEST_`-prefix maps and the FunctionalTest Blueprints?



# UE4 Automation Tool

URL: https://blog.squareys.de/ue4-automation-tool/
Author: Jonathan Hale
Date: 2019-05-2019
Unreal Engine Version:

All automation is controlled with Unreal Engine Automation Tool (UAT).
This includes CI, automated builds and local testing.
Located at `Engine/Build/BatchFiles/RunUAT.(bat)|(sh)`.
`-list` gives a list of commands.
Automation subcommands are listed with
```
RunUAT -game -buildmachine -stdout -fullstdoutlogoutput -forcelogflush -unattended -nopause -nullrhi -nosplash -ExecCmds="automation -list; quit"
```
> This should print a list of automation subcommands, but I get the following error:
> Unknown parameter -game in the command line that does not belong to any command.
> Removing `-game`.
> Same for `-buildmachine`.
> Same for `-stdout`.
> Same for `-fullstdoutlogoutput`.
> Same for `-forcelogflush`.
> Same for `-unattended`.
> Same for `-nopause`.
> Same for `-nullrhi`.
> Same for `-nosplash`.
> Same for `-ExecCmds=automation`.
> And that's all of them. Nothing works.

Help for a command is printed with `-ExecCmds="automation -help TestFileUtility; quit"`
> I don't expect this will work.

Tests are run with the `RunTests` subcommand.
Demonstrated using Unreal Editor instead of UAT.
```
UE4Editor.exe
YourProject.uproject
-Game
-NullRHI
-NoSound
-ExecCmds="Automation RunTests MyCategory"
-TestExit="Automation Test Queue Empty"
-Log
```
> Why the editor instead of UAT all of a sudden?
> This is very similar to what the other instructions say.

`-ExecCmds` is the command to run.
To run a (set of) test(s): `Automation RunTests <Group|Test|"All">`.
Multiple tests are separated by whitespace.
`-TestExit` specifies when to exit the automation tool.
In this case when the test queue is empty.
> When is a test considered to be out of the queue?
> Is it in the queue for as long as there are latent commands waiting to complete?
> I assume so.

There is a third-party command line tool named `ue4cli`.
Helps with these kinds of things.
Available in the `pip` repositories.



# UE4 Automation Testing

URL: https://blog.squareys.de/ue4-automation-testing/
Author: Jonathan Hale
Date: 2018-08-12


## Automation Tests

Automation tests are small programs that test your code for correctness.
Ensure that it actually does what it is supposed to.
Ensure that it still works after a change.
They are automatic and easy to run.
Should be done often, preferably automatically through some trigger.


## Framework in UE4

Unreal Engine has a framework that helps.
Supports asynchroneous calls, eg loading a map and wait for it to complete.
Documentation is bad, read Automation framework source code and engine tests instead.


## Test Plugin Setup

Keep tests separate, as a separate module or plugin.
Can exclude tests from shipped packages.
Set the modules `Type` to `Developer`.
> Not sure where to do this. The `.uplugin` file I guess.
> The `Developer` type was removed in Unreal Engine 4.25.
> Use `DeveloperTool` instead.

Full `.plugin` example:
```json
{
    "FileVersion": 3,
    "Version": 1,
    "VersionName": "1.0.0",
    "FriendlyName": "Your Game Tests",
    "Description": "Automation tests for YourGame.",
    "Category": "Testing",
    "CreatedBy": "You",
    "CanContainContent": true,
    "Installed": false,
    "Modules": [
        {
            "Name": "YourGameTests",
            "Type": "Developer",
            "LoadingPhase": "Default"
        }
    ]
}
```
> The important part for us is the single module.

Create a `Build.cs` file in the `Source/<module name>\` directory.
```c#
using UnrealBuildTool;

public class YourGameTests : ModuleRules
{
    public YourGameTests(ReadOnlyTargetRules Target) : base(Target)
    {
                PCHUsage = ModuleRules.PCHUsageMode.UseExplicitOrSharedPCHs;
                PrivateDependencyModuleNames.AddRange(new string[] {
                    "Core",
                    "Engine",
                    "CoreUObject",
                    "YourGame"
                });
    }
}
```
> Mostly basic stuff. The inclusion of "YourGame" is important, but should probably
> be our other plugins in our case.

New modules require some scaffolding in its `.cpp` file:
```c++
#include "YourGameTests.h"
#include "Modules/ModuleManager.h"

IMPLEMENT_MODULE(FDefaultModuleImpl, YourGameTests);
```


## Writing a test

Place test sources in a `Test` subfolder.
Test `.cpp` files should be named `<something>Test.cpp`.
Example implementation:
```c++
#include "YourGameTests.h"

#include "Misc/AutomationTest.h"
#include "Tests/AutomationCommon.h"
#include "Engine.h"
#include "EngineUtils.h"

#include "YourGameModeBase.h"
#include "MyEssentialActor.h"

// Copy of the hidden method GetAnyGameWorld() in AutomationCommon.cpp.
// Marked as temporary there, hence, this one is temporary, too.
UWorld* GetTestWorld() {
    const TIndirectArray<FWorldContext>& WorldContexts = GEngine->GetWorldContexts();
    for (const FWorldContext& Context : WorldContexts)
    {
        if (((Context.WorldType == EWorldType::PIE) || (Context.WorldType == EWorldType::Game))
            && (Context.World() != nullptr))
        {
            return Context.World();
        }
    }

    return nullptr;
}

IMPLEMENT_SIMPLE_AUTOMATION_TEST(FGameTest, "YourGame.Game",
    EAutomationTestFlags::Editor |
    EAutomationTestFlags::ClientContext |
    EAutomationTestFlags::ProductFilter)

bool FGameTest::RunTest(const FString& Parameters) {
    AutomationOpenMap(TEXT("/Game/Levels/StartupLevel"));

    UWorld* world = GetTestWorld();

    TestTrue("GameMode class is set correctly",
        world->GetAuthGameMode()->IsA<YourGameModeBase>());
    TestTrue("Essential actor is spawned",
        TActorIterator<AMyEssentialActor>(world));

    return true;
}
```

> Things to note:
> Include `Misc/AutomationTest.h` and `Tests/AutomaitonCommon.h`.
> You can include your own headers.
> Thanks to the module dependency.
> It's complicated to get hold of the World.
> Unclear if this implementation still works.
> Tests are declared with the `IMPLEMENT_SIMPLE_AUTOMATION_TEST` macro.
> Tests are defined with the `RunTest` member function.

There are some helper functions, such as `AutomationOpenMap` and `TestTrue`,
`TestNotNull`, `TestEqual`, and so an.
The test framework doesn't differentiate between Actual and Expected
in TestEqual. Pick one and be consisten.
> I believe it does now; actual first, expected second.


## Latent Commands

Sometimes ticking is required before a test can be performed.
Sometimes a asynchroneous operation must finish, such as level loading.
This is done with Latent Commands.
They have an `Update` member function that returns true when done waiting.
New Latent Commands are created with `DEFINE_LATENT_AUTOMATION_COMMAND_ONE_PARAMETER`.
Example:
```c++
DEFINE_LATENT_AUTOMATION_COMMAND_ONE_PARAMETER(FMyCommand, FGameTest*, Test);
bool FMyCommand::Update() {
    if(!SomethingHasHappened) {
        return false; // Try again later.
    }

    Test->TestTrue("SomethingWasCaused", SomethingWasCaused);
    return true; // Command completed.
}
```
Add the following to a `RunTest` member function definition:
```c++
ADD_LATENT_AUTOMATION_COMMAND(FMyCommand(this));
```
All subsequent tests must also be Latent Commands to guarantee ordering.
Makes writing tests tedious.
By passing in `this` from `RunTest` to the Latent Command we get access to the `Test*` family of functions.
We can pass other things as well, just declare them in the macro call.
Use `DEFINE_LATENT_ATUOMATION_COMMAND_TWO_PARAMETER` for two parameters.
Notice non-plural form of `PARAMETER`.



# UE4 Unit Tests in Jenkins

URL: https://www.emidee.net/ue4/2018/11/13/UE4-Unit-Tests-in-Jenkins.html
Author: MICHAEL DELVA
Date: 2019-11-13

It is straightforward to run tests from within the ditor.
Use the Session Frontend.
In Jenkins is more difficult.
Contents of jenkinsfile:
```bash
bat returnStatus: true, script: "\"${env.UE_ROOT_FOLDER}/Engine/Binaries/Win64/UE4Editor-Cmd.exe\"
    \"${env.WORKSPACE}/${env.PROJECT_NAME}.uproject\"
    -unattended -nopause
    -NullRHI
    -ExecCmds=\"Automation RunTests ${env.PROJECT_NAME}\"
    -testexit=\"Automation Test Queue Empty\" -log -log=RunTests.log
    -ReportOutputPath=\"${env.WORKSPACE}/Saved/UnitTestsReport\""
```
Prefixing unit tests with project names makes it easy to run all tests.
Project name becomes the root of all tests in the test name hierarchy.
`NullRHI` is used to avoid instantiate the whole editor.
`testexit` is a pattern that when logged causes the engine to stop and shut down.
`unattended` Disable anything requiring feedback from user.
`nopause` Close the log window automatically on exit.
`ReportOutputPath` Directory where to place report JSON.

The resulting JSON must be converted to JUnit XML.
Some Python code to do this is supplied.
> I won't paste it here.

The test definition uses the following `EAutomationTestFlags`:
- ApplicationContextMask
- ProductFilter




# Harnessing the Unreal Engine Automation Framework for Performance Measurement

URL: https://www.unrealengine.com/en-US/events/unreal-fest-online-2020
Author: Jonathan Quinn, Jonas Nelson (Dovetail Games)
Date: 2020-06-14

This is a presentation.
Latent Commands can be defined by hand so that members are easier to declare.
Inherit from `IAutomationLatentCommand`.
```c++
class FSomethingCommand : public IAutomationLatentCommand
{
public:
    FSomethingCommand(<parameters>)
        : <member initialization>
    {
    }

    virtual bool Update() override
    {
        <check or action>
        <update members>
        return true if done, false if we should Update again next tick.
    }
private:
    <members>
};
```
Latent command member variables can be references to get data sharing between commands.
References to members of the Test that is running the Latent Commands.

Shows how to get the world: `TestHelpers::GetWorld()`.
Not sure if `TestHelpers` is bult-in or not. I think not.
I guess one can use a combination of `GEngine->GetWorldContexts();`, `Context.WorldType == EWorldType::`, and `Context.World()` to find a suitable world.
But which one is the correct one? No idea.

Test are defined as subclasses of `FAutomationTestBase`.
Here we store data that is shared between multiple Latent Commands.
The strings put into `OutTestCommands` will be passed as a parameter to `RunTest`.
Create one instance of the Test class in the anonymous namespace.
```c++
class FSomethingTest : public FAutomationTestBase
{
public:
    FSomethingTest(const FString& InName, const bool bInComplexTask)
        : FAutomationTestBase(InName, bInComplexTask)
    {
    }

    void GetTests(TArray<FString>& OutBeutifiedNames, TArray<FString>& OutTestCommands) const
    {
        <add names such as "MyProject.Something" to OutBeutifiedNames and
        parameters to RunTest to OutTestCommands.>
    }

    bool RunTest(const FString& InParameter)
    {
        <Add commands with ADD_LATENT_AUTOMATION_COMMAND(FSomethingCommand(<parameters>));>
        return true if commands successfully added, false otherwise.
    }

private:
    <members>
}

namespace
{
    FSomethingTest SomethingTest(TEXT("SomethingTest");
}
```
The test is run by adding `-ExecCmds="Automation RunTests MyProject.Something;Quit"` to the command line.
> The .-notation seems to be clever enough to realize that "Something" is a subtest that
> is generated dynamically by "FSomethingTest" and not defined at compile time.
> The Quit part is to shut down the game when the test has finished.
> I think it's equivalent to `-TestExit="Automation Test Queue Empty"`.
> Not sure what the prefered exit strategy is.

> Quite high-level. Or at least not enough time spent on the test writing part
> that I want to know about. Much about the pipeline built on top of the
> Automation framework.




# Automated functional testing in UE4

URL: https://www.youtube.com/watch?v=HscEt4As0_g
Author: Paul Gestwicki
Date: 2019-10-10

YouTube video.
Shows to to create a level, a Functional Testing Blueprint and some actors to test game functionality.


# Ticking the world from a test

URL: None yet

I want to know how to step the game world as part of an Automation Test.
Currently, when the test is running we don't seem to have an actual game instance up.
I.e., there is no `GameInstance` available.
The `UWorld` returned by `<fill in here>` does increment its `GetTimeSeconds`,
but Actors in it does not move.

https://answers.unrealengine.com/questions/967371/automation-tests-using-subsystem.html says that
we can create a new `GameInstance` using `NewObject`, but I'm not sure that's what I want.
Is the `GameInstance` stand-alone enough?
Can I step/tick it from the test and have it run a full game?

https://gist.github.com/namelessvoid/489d704707630e61bb67fae88bb2f406 talks about how to get the PIE world from a test.
Again, not sure this is what we want to do.
When running the unit tests from the command line there is no editor.
At least not as a graphics window.
Does the editor exist anyway, including the PIE world?
Is the PIE world being ticket while the test is running?
The code it shows comes from https://answers.unrealengine.com/questions/303577/automation-testing-on-binary-engine-is-broken.html
I think there is a difference between including the `-Game` parameter or not when starting the tests.

https://docs.unrealengine.com/en-US/Programming/Automation/TechnicalGuide/index.html uses `FEngineAutomationTestUtilities::LoadMap`.
A `grep` in `Engine/Source` doesn't find anything named `FEngineAutomationTestUtilities`.
https://forums.unrealengine.com/development-discussion/c-gameplay-programming/24661-api-class-reference-for-automation-system
says that it doesn't exist and that the official documentation is out of date.
Suggests using `FLoadGameMapCommand` or `UEditorLoadingAndSavingUtils` instead.
Both of these exist.
`UEditorLoadingAndSavingUtils` seems a bit like editor internals. Don't like it much.
`FloadGameMapCommand` is in `AutomationCommon.h`, which is exactly what I want.



During test setup I had an issue where time would not progress in my world. Stuck at 5.24 s something.
I want world ticking because I want to ensure that Actors behave as expected.
To debug I created a small stand-alone test in a brand new C++ Unreal Engine project.
There it worked as expected.
My test:
```c++
#include "Misc/AutomationTest.h"
#include "Tests/AutomationCommon.h"
#include "Engine/World.h"
#include "Engine/Engine.h"

struct FState
{
    int32 CurrentUpdate = 0;
    int32 MaxUpdates = 10;
    float TimeAtFirstUpdate;
    float TimeAtLastUpdate;
    float Duration;
    UWorld* World;

    bool Update()
    {
        ++CurrentUpdate;
        if (CurrentUpdate == 1)
        {
            TimeAtFirstUpdate = World->GetTimeSeconds();
        }
        if (CurrentUpdate > MaxUpdates)
        {
            TimeAtLastUpdate = World->GetTimeSeconds();
            Duration = TimeAtLastUpdate - TimeAtFirstUpdate;
            return true;
        }
        return false;
    }
};

DEFINE_LATENT_AUTOMATION_COMMAND_ONE_PARAMETER(FWaitForTicking, FState&, State);
bool FWaitForTicking::Update()
{
    bool bDone = State.Update();
    UE_LOG(LogTemp, Warning, TEXT("After %d updates, time is %f."),
           State.CurrentUpdate, State.World->GetTimeSeconds());
    if (bDone)
    {
        UE_LOG(
            LogTemp, Warning,
            TEXT("Ending test after %d updates. World time is now %f and we spent %f seconds."),
            State.CurrentUpdate, State.TimeAtLastUpdate, State.Duration);
    }
    return bDone;
}


UWorld* GetTestWorld()
{
    const TIndirectArray<FWorldContext>& Contexts = GEngine->GetWorldContexts();
    for (const FWorldContext& Context : Contexts)
    {
        if (Context.WorldType == EWorldType::Game && Context.World() != nullptr)
        {
            return Context.World();
        }
    }
    return nullptr;
}


IMPLEMENT_SIMPLE_AUTOMATION_TEST(
        FTickingTest, "AutomationTick.Ticking",
        EAutomationTestFlags::ApplicationContextMask | EAutomationTestFlags::ProductFilter)
bool FTickingTest::RunTest(const FString&)
{
    static FState State;
    State.World = GetTestWorld();
    UE_LOG(LogTemp, Warning, TEXT("Test is running."));
    ADD_LATENT_AUTOMATION_COMMAND(FWaitForTicking(State));
    return true;
}
```

This was run with the command line:
```
$UE_ROOT/Engine/Binaries/Linux/UE4Editor
~/UnrealProjects/AutomationTick/AutomationTick.uproject
-NoSound
-Game
-NullRHI
-NoSplash
-Unattended
-ExecCmds="Automation RunTests AutomationTick.Ticking"
-TestExit="Automation Test Queue Empty"
```
Here I get the output I want, increasing world times.
Then I added latent map loading by inserting
```
ADD_LATENT_AUTOMATION_COMMAND(FLoadGameMapCommand(TEXT("Test_ActorBehavior")))
ADD_LATENT_AUTOMATION_COMMAND(FWaitForMapToLoadCommand())
```
before the `FWaitForTicking` `ADD_LATENT_AUTOMATION_COMMAND`. Broke. Time stopped.
Theory: The world is replaced when a new map is loaded. Our old `UWorld` pointer is invalidated.
Creating new Latent Command to fetch the World later, after map loading.
Didn't help, still seeing t=5.26 on the first update.
Are there multiple worlds now?
I give up.



# AN INTRODUCTION TO AUTOMATED TESTING FOR AN UNREAL ENGINE PROJECT

URL: https://kobiton.com/automation-testing/an-introduction-to-automated-testing-for-an-unreal-engine-project/
Author: Anh Ninh
Date: 2020-06-15
Unreal Engine Version: 4.25

## Unit Tests

To add the `#if WITH_DEV_AUTOMATION_TESTS` macro before the function definition.



# AnswerHub, StackOverflow, and similar Q&A sites


## Engine Latent Commands

URL: https://answers.unrealengine.com/questions/428323/view.html

Question:

I'm trying to write some custom automated test for our game and editor. There
area lot of handy LatentCommands such as FWaitLatentCommand(), but when I try to
access these in editor tests I get linker errors. Compiling the game works just
fine. What am I missing?

Answer:

Change the define macros of the functions you'd like to use from
`DEFINE_LATENT_AUTOMATION_COMMAND` to `DEFINE_ENGINE_LATENT_AUTOMATION_COMMAND`
(this works with the `ONE_PARAMETER` versions as well)


## Results of an automation test

URL: https://answers.unrealengine.com/questions/364378/view.html

Question:

Hello! I've tried to write automation test by this guide
https://docs.unrealengine.com/latest/INT/Programming/Automation/TechnicalGuide/index.html
and I've ran it from CLI by command `UE4Editor.exe GAMENAME -Game
-ExecCmds="Automation Run FMyTest"`. But I don't see any results. I mean, that I
see launched game, but I don't see results of tests in CLI or in game's
window. How can I see results of them?

Answer:

Ok, it seems, that results are available only in log file. So, this command is
useful for me:

`./UE4Editor /path/to/project_file -ExecCmds="Automation Run [test classes separated by space]" LOG=/path/to/logfile -Game`

After executing I see the log file. Under Linux I use grep for filtering.

> This does not work for me.
> `LOG` should be `ABSLOG` instead, to get an absolute path. (Is that really what `ABSLOG` means?)
> No automation run seems to happen.
> At least, there is no mention of the test I list in the log file.
> My command line:
> `./UE4Editor ~/UnrealProjects/MyProject/MyProject.uproject -nosound -ExecCmds="Automation Run MyTests.StringUtilities" ABSLOG=~/ue_tests.log -Game`
> After reading some more, trying `Automation RunTests` instead of `Automation Run`.
> Something happened. I get `Automation: RunTests='MyTests.StringUtilities' Queued.` in the log.
> No results though.
> Making the test fail.
> No change. It doesn't run. Only queued.


## Getting Unit Tests to Show Up

URL: https://answers.unrealengine.com/questions/387183/view.html

Question (abbrev):

My question is what witchcraft do I have to do to get them to show up in Unreals UI?

Answer (abbrev):

You have to restart the editor for the frontend tests to update correctly.
Don't name the test the same as the class being tested.


## Is it possible to add an AutomationTest in a game module?

URL: https://answers.unrealengine.com/questions/74804/view.html

Question:

I would like to add some unit tests for code contained in the game module. I'm
following the documentation found at
https://docs.unrealengine.com/latest/INT/Programming/Automation/TechnicalGuide/index.html,
registering the AutomationTest using `IMPLEMENT_SIMPLE_AUTOMATION_TEST` and
including its corresponding RunTest method.

However, seems like the test is not registered, and never shows up in the
Session Frontend > Automation list.

Are Automation Tests only intended for Engine modules? Or perhaps I'm missing an
undocumented step?

Answer:

Good news, AutomationTest are fully functional from Game module. I've got I
first failing test working, just adding a source file `MyClassTest.cpp` inside a
`/Test` folder in my regular game source dir.
`Engine/Source/Runtime/Core/Private/Tests/` should be a good starting point!

Comment:

It is working. My mistake was using `ATF_Game` as test flag, it leaves the test
out from running in the editor. Using `ATF_SmokeTest` (or `ATF_Editor`,
`ATF_ApplicationMask`) allows the test class to appear on the Session Frontend
list.

> I think `ATF_` is now called `EAutomationTestFlags::`
> I don't think one should mark tests `Smoke` just to get them to show up.
> Maybe `ApplicationMask` is better, or include both Editor and Client contexts.
> I'm not sure that ClientContext is the same as starting the game with `./UE4Editor -Game`.


## Using automation testing for catching expected errors

URL: https://answers.unrealengine.com/questions/674751/view.html

Question:

Suppose I have a piece of program that logs an error.

```c++
void DoStuff(bool doit)
{
    if(!doit)
    {
        UE_LOG(MyLogCategory, Error, "Cannot do stuff");
    }
}
```

And I write an automation test that actually expects this log to be printed.

```c++
IMPLEMENT_SIMPLE_AUTOMATION_TEST(
    DoStuffTest,
    "DoStuffTest.ThrowsError",
    EAutomationTestFlags::EngineFilter | EAutomationTestFlags::EditorContext)

bool DoStuffTest::RunTest(const FString& Parameters)
{
    DoStuff(false);
    // TODO: Assert that an error was logged and make the test pass.
}
```

How can I ensure that my test passes? It now directly fails, because of the
`UE_LOG` in the actual source code.

Answer:

You'd want to use `AddExpectedError` in the test body, which allows you to
define a regex describing the expected error/warning message, the type of
comparison to perform, and the number of times you expect the message to occur
during the test.

Example from one of the unit tests:

```c++
AddExpectedError(TEXT("Response \\(-?\\d+\\)"), EAutomationExpectedErrorFlags::Contains, 4);
AddError(TEXT("Response (0)"));
AddError(TEXT("Response (1)"));
AddError(FString::Printf(TEXT("Response (%d)"), MIN_int64));
AddError(FString::Printf(TEXT("Response (%d)"), MAX_uint64));
```

From your example, your test would look something like:

```c++
IMPLEMENT_SIMPLE_AUTOMATION_TEST(
    DoStuffTest,
    "DoStuffTest.ThrowsError",
    EAutomationTestFlags::EngineFilter | EAutomationTestFlags::EditorContext)

bool DoStuffTest::RunTest(const FString& Parameters)
{
    AddExpectedError(TEXT("Cannot do stuff"), EAutomationExpectedErrorFlags::Exact, 1);
    DoStuff(false);
}
```


## unit test: custom UGameInstance

URL: https://answers.unrealengine.com/questions/600682/view.html

Question:

I have my own implementation of UGameInstance derived class. I'd like to test
some of its methods in unit tests, that is using the
`IMPLEMENT_SIMPLE_AUTOMATION_TEST()` macro. My problem is that
`GEngine->GetWorld()` is always nullptr during the test execution, therefore I'm
not able to get the instance of my class with `UWorld::GetGameInstance()`
method.

How do I get any world in unit test? How do I get Game Instance object in unit test?

I think this one is related, but no good answer:
https://answers.unrealengine.com/questions/148164/unit-testing-methods-in-custom-gamestate-class.html

Answer:

> No answer, but I think we want to know how to get access to the World so I'm
> leaving this in for now.


## Unit testing methods in custom gamestate class.

URL: https://answers.unrealengine.com/questions/148164/unit-testing-methods-in-custom-gamestate-class.html

Question:

I have a custom class (`ALevelGameState`) that is a child of `AGameState`. I've
added a couple methods and one property for tracking player points and I'd like
to run unit tests on them using the automation tab in session frontend (or
anyway to run unit tests...). I've setup the simple test using
`IMPLEMENT_SIMPLE_AUTOMATION_TEST` like in the automation tech guide. However
anytime I try to create an `ALevelGameState` object and call my `getScore` method,
using something like I did in my custom gamemode class, I get read reference
errors at runtime. Is there a special setup or dependencies I also need to
create in order to unit test my custom gamestate? I noticed that `AGameMode`
calls: `GameState = GetWorld()->SpawnActor(GameStateClass, SpawnInfo);`. Do I have
to launch a game and a map in order to test with gamestate, or any actor related
class?

Answer:

Are you passing in `ATF_Game` to `IMPLEMENT_SIMPLE_AUTOMATION_TEST()\`? I don't
think those show up in Session FrontEnd. You can try changing it to `ATF_Editor`
if your unit tests don't need `GEngine`.

> This is worrying. Is there a difference in what is accessable between Game tests
> and Editor tests? What is a Game test these days?


## Run automated testing from command line

URL: https://answers.unrealengine.com/questions/106978/run-automated-testing-from-command-line.html
Date: 2014-10-01

Question:

Greetings, In BuildTools presentation (https://www.unrealengine.com/resources) I
found that I can run tests with command line. Can someone provide an example
please?

Answer:

> Lots of discussion on this one. I will summarize the most important findings here.
> Quite old though, so not sure how much of this is true anymore.
> In the end, what runs the tests on my machine (Linux, UE4.22) is:

```
./UE4Editor ~/UnrealProjects/MyProject/MyProject.uproject -nosound -ExecCmds="Automation RunTests MyProject.MyTest"  -Unattended -NullRHI -TestExit="Automation Test Queue Empty" -ReportOutputPath="/home/test_reports/MyProject" -log ABSLOG=/home/test_reports/MyProject.log
```

- `./UE4Editor`: The Unreal Editor binary.
- `~/UnrealProjects/MyProject/MyProject.uproject`: Path to the project.
- `-nosound`: Because Unreal Editor freezes after Play-in-Editor with sounds.
- `-ExecCmds="Automation RunTests MyProject.MyTest"`: The name of the test(s) to run.
- `-Unattended`: Disable anything requiring feedback from user.
- `-NullRHI`: Disable graphics.
- `-NoSplash`: Disable loading splash screen.
- `-TestExit="Automation Test Queue Empty"`: When to quit. Pattern matching on the log, I believe.
- `-ReportOutputPath="/home/test_reports/MyProject"`: File system directory to put test result files into.
- `-log ABSLOG=/home/test_reports/MyProject.log`: Enable logging and path to the log file.

> The process exit status is `EXIT_SUCCESS` even when a unit test fails so the resulting
> \`index.json\` file must be parsed to detect success/failure.
>
> NOTE: I'm not sure if `-Game` should be passed or not.
> Did not for a while and it seemed to work for simple things, but now I started adding
> scene loading, archive import, and stepping/ticking.
> It could be that I must add `-Game` now.


## How do you run tests from the command line?

URL: https://stackoverflow.com/questions/29135227/how-do-you-run-tests-from-the-command-line
Date: 2015-03-19
Unreal Engine Version: 4.10.

Question:

To do this in-editor you open the automation tab, connect to the session and
choose which tests to run. How do you do it from the command line?

Answer:

```
UE4Editor.exe
path/to/project/TestProject.uproject
-ExecCmds="Automation RunTests SourceTests"
-unattended
-nopause
-testexit="Automation Test Queue Empty"
-log=output.txt
-game
```

> This is basically what I had from the previous Q&A.
> `-nopause` and `-game` has been added.
> Not sure if I should pass `-Game` or not.
> For some tests I want the game to run for a bit.
> This answer does not use `-NullRHI`. I think I should.


## How can automation testing be used for checking in game things?

URL: https://answers.unrealengine.com/questions/386066/how-can-automation-testing-be-used-for-checking-in.html
Date: 2016-03-07
Unreal Engine Version: 4.10

Question:

I have written some automation tests for unreal replicating basic unit tests,
all using the `EAutomationTestFlags::ATF_SmokeTest` flag. However, I have seen
that it can be a lot more useful, making use of the in game and in editor flags,
etc. I have tried to copy some of these from the engine tests etc which I have
found, but still no idea where to go.

For example, how would I run the game, and have ti test that all maps load in
game? (I have seen the test written for this but cannot get it to work).

http://pastebin.com/PwJUv1FH

Answer (abbrev):

Don't mix latent and non-latent code.
Because non-latent will run immediately and latent code will run later.
A level load is required to get Actors etc created.
If not, all the latent commands that search for stuff won't find anything.
Not waiting for the level to load completely will also cause latent commands to not find anything.
Put a latent commands early in the queue that does the waiting.
Possibly using an `TObjectIterator` (or similar) to make sure the things you need are really there.
```c++
bool FWaitForCharacter::Update()
{
    for (TObjectIterator<ACharacter> it; it; ++it)
    {
        ACharacter* character = *it;
        if (character)
        {
            return true;
        }
    }
    return false;
}
```
A proper wait event is better than a hard-coded timed wait.
Put another latent command last to do any cleanup.
