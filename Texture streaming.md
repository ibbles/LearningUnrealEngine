2022-01-27_18:11:08

# Texture Streaming

Print a list of the currently loaded textures by running
```
ListStreamingTextures
```
in the console.
Will be printed to the output log.

## Limiting maximum texture size

Some of the links below suggest writing to `DefaultEngine.ini`.
I never got that to work, textures would stream in at 8K anyway and overflow the texture pool.
Instead I did
- Top Meny Bar > Window > Developer Tools > Device Profiles
- Click the three dots on each and every one in the list to the left.
- Edit the 

https://answers.unrealengine.com/questions/491882/how-to-see-what-is-in-texture-pool.html  
https://answers.unrealengine.com/questions/343646/texture-streaming-pool-over.html  
https://unrealbyfusilade.wordpress.com/pc-gaming/batman-arkham-asylum/defaultengine-ini/  
https://github.com/iFunFactory/apps-ue4-dedi-server-example/blob/master/ShooterGame/Config/DefaultEngine.ini  


https://docs.unrealengine.com/4.27/en-US/RenderingAndGraphics/Textures/SupportAndSettings/  
https://docs.unrealengine.com/4.27/en-US/RenderingAndGraphics/Textures/SupportAndSettings/