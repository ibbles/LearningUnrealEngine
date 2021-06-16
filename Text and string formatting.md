2021-06-08_16:47:36

# Text and string formatting

## Text

```cpp
return FText::Format(
        LOCTEXT("TextID", "Text before number. {0} Text after number."),
        FText::AsNumber(MyNumber));
```

```cpp
FFormatNamedArguments Arguments;
Arguments.Add(TEXT("MyArgumentID"), FText::AsNumber(MyNumber));
// Can have multiple Arguments.Add here.
FText DialogText = FText::Format(
    LOCTEXT("TextID", "Text before number. {MyArgumentID} Text after number."),
    Arguments);
```

## String

