2020-11-17_20:26:44

# Textures

## Sizes

Texture sizes should always be a power of  2.
The side size, that is.
Does not need to be square.
Required for MipMaping and texture streaming.
Which in turn is required for performance.

## Alpha

Separate vs embedded alpha.
Separate: Alpha is read from a separate texture.
Embedded: Alpha is in the texture channels itself.

Embedded alpha uses more memory because the alpha channel is not compressed.
A separate alpha makes it possible to have a different sized alpha compared to the base color.
This can be used to reduce memory usage and increase performance while retaining base color fidelity.
A drawback of separate alpha is that it consumes an extra texture sampler, which is a limited resource.

## Mask packing

Store data for different use in the different channels of a texture.
Gives four single-channel textures per texture asset.
Set the texture sampler's Type to `Masks` in the Material.
Disable sRGB for masks.

## Color spaces

There are two colors spaces in Unreal Engine: linear and sRGB.
The sRGB color space is gamma corrected. (I think)
When using a texture for things other than color sRGB should be turned off.
Examples include normal maps and masks.
sRGB can be enabled or disabled in Details Panel > Texture > sRGB.

## MipMaps

MipMaps is a type of LOD for textures.
Important for performance.
A sequence of MipMap levels for a texture is called a MIP chain.
Half-resolution version at each step.
MipMap generation happens when a texture is imported.
The automatic default settings are usually good enough.
Filtering is sometimes configured.
Necessary for texture with small lines, which can cause shimmering.
It's a setting on the texture asset called Mip Gen Settings under Level Of Detail.
If you see such shimmering, try to change Mip Gen Settings to Sharpen or Blur.
Different settings solves different types of problems, the only way to know is to try.
Setting LOD Bias for a texture high causes a smaller MipMap to be used, which causes the texture to look blurry.
Each step of the LOD Bias halves the number of texels per side.
LOD bias zero means use the full size texture.
Textures that don't have power of two sides will not have any MipMaps, will always use full size.

## Compression

Textures can be compressed.
On the Texture asset find Details Panel > Compression > Compression Settings.
`VectorDisplacementMap` and `UserInterface2D` produces uncompressed textures.
Will produce very large memory usage.

## Texture groups

Each texture belong to a texture group.
Unreal Engine comes with a collection of default texture groups.
Not sure if possible to add our own texture groups.
The texture group a particular texture asset belong to is set in Level Of Detail > Texture Group.
Some texture settings are applied per texture group.
- `MinLODSize`, `MaxLODSize`, `LODBias`, `MinMagFilter`, `MipFilter`, ...
These are set in the `[SystemSettings]` in the `.ini` file.
Texture groups are a good way to run performance experiments.
Simply increase the LODBias of a texture group to reduce the memory usage for all textures in that group.

## Importing textures
Textures can be imported using drag-and-drop from a file explorer.
Can also be imported using the Import button at the top of the Content Browser.
Unreal Engine tries to detect what type of texture, such as normal map, is being imported.
Various settings are automatically configured based on what type of texture was detected.

Supported formats:
With alpha support: `PNG`, `PSD`, `TGA`.
Without alpha support: A bunch of them.

HDR format for cube maps do not need to obey the power of two rule.


## Use in UMG widgets

To add a texture to an UMG widget, add an Image widget from the Palette.
To update the texture, call Set Brush From Texture on the Image widget.

[[2020-05-10_11:01:04]] [Materials](./Materials.md)  
[[2020-03-10_21:23:32]] [Naming convention](./Naming%20convention.md)  