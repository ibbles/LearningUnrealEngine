2022-02-01_17:30:59

# Deprecating UProperties

The regular way one changes the content of an UObject while maintaining backwards compatibility is to deprecate one or more UProperties and adding new ones in their place.
A UProperty is deprecated by appending `_DEPRECATED` to its name, moving it to the `private` section of the class, and removing all Property Specifiers from the `UPROPERTY` macro.
