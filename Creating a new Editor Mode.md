2021-02-19_08:22:29

# Creating a new Editor Mode

An Editor Mode replaces the regular user input tools (select, move, etc) with ones designed for a specific purpose.
For example Landscape painting or foliage manipulation.
An Editor Mode can also create additional Panels in the Editor window.
New Editor Modes are created in C++.
All code described and exemplified here should be but in an Editor Module.

A new Editor Mode is created by inheriting from the `FEdMode` class.
```cpp
#include "EdMode.h"
class MYMODULE_API FMyEdMode : public FEdMode
{
}
```

Each Editor Mode has a unique identifier `FName` that we should specify.
```cpp
class MYMODULE_API FMyEdMode : public FEdMode
{
public:
    static const FEditorModeID EM_MyEdModeId;
}
```
```cpp
const FEditorModeID FMyEdMode::EM_MyEdModeId = TEXT("EM_MyEdMode");
```

`FEdMode` has a few virtual member functions that we can override.
```cpp
class MYMODULE_API FMyEdMode : public FEdMode
{
public:
	bool UsesToolkits() const override;
	virtual void Enter() override;
	virtual void Exit() override;
}
```

An Editor Mode can optionally use a Toolkit.
The Toolkit is what provides the Mode's GUI elements.
Add `return true` to the `UsesToolkits` implementation to enable toolkits.

```cpp
class MYMODULE_API FMyEdModeToolkit : public FModeToolkit
{
}
```

There is also `FBaseToolkit` as an even more low-level base class.
`FModeToolkit` gives you an UI panel for selectable tools and a Details Panel for the selected tool.

[[2020-12-03_10:41:49]] [Editor Mode](./Editor%20Mode.md)  
[[2021-02-19_08:26:26]] [Editor module](./Editor%20module.md)  


[How to Make Tools in UE4 @ lxjk.github.io](https://lxjk.github.io/2019/10/01/How-to-Make-Tools-in-U-E.html)