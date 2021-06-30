2021-06-22_12:28:21

# Class Default Object

Each UObject subclass has a Class Default Object.
This is an instance that is created at engine startup using the default constructor.
Changes made to UProperties on the Class Default Object are propagated to other instances of that class unless the instance had value different from the previous Class Default Object value.

[Unreal Object Handling @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/Objects/Optimizations/) talks about these updates being applied at load time.
I believe the same thing happens immediately when compiling a Blueprint in the editor.

The matching override check isn't applied when reparenting from one base class to another.
Consider the following pseudo-code example:
```cpp
Blueprint UBase1
{
    UProperty P;

    FBase1()
    {
        P = 1;
    }
}

Blueprint UDerived : UBase1
{
}

UDerived Derived;

// Derived.P is now 1, equal to the Class Default Object value.

Blueprint Base2
{
    Property P;

    Base2()
    {
        P = 2;
    }
}

Drived.SetParentClass(Base1);

// Derived.P is still 1, which is different from the Class Default Object value.
// The Class Default Object has P=2 since the inherited constructor sets it to 2.
// Derived.P is now considered to be overriding the base class value for P since
// the value is different, even though we never overrided it.
```

I'm not entirely sure that the above is correct.
It may be that the above process only occurs if the UProperty is on a Scene Component that is nested beneath another in the Blueprint's Scene Component hierarchy.

[[2021-06-22_08:34:55]] [UProperties](./UProperties.md)  


[Unreal Object Handling @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/Objects/Optimizations/)  
