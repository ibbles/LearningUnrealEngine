2021-08-19_21:55:41

# Creating HUD in Blueprint

## Building the HUD contents

The HUD is a UMG widget created in the Content Browser.
Content Browser > right-click > User Interface > Widget Blueprint.
Populate Canvas Panel in the Hierarchy Panel with widgets from the Palette Panel.

(
TODO: Make a dedicated note with more details.
)


## Instantiating the HUD

I have seen various ways of doing this.

One is to create it from the Game Mode's Event Graph.
Begin Play > Create Widget (Class=MyWidget) > Add To Viewport.

One is to create it from the Player Controller's Event Graph.
Begin Play > Create Widget (Class=MyWidget) > 


[Making Your First Game in Unreal Engine 4 // 5-1 Designing the HUD by Ryan Laley @ youtube.com](https://youtu.be/z8f2KToeKBE?list=PL4G2bSPE_8uk84cmXmVO-uS8ioIXEJkh0&t=583)

[[2020-08-06_13:52:59]] [Creating HUD in C++](./Creating%20HUD%20in%20C++.md)  
[[2020-11-08_15:42:25]] [HUD](./HUD.md)  
[[2020-05-10_10:35:51]] [GUI-HUD](GUI-HUD.md)  