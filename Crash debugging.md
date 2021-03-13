2021-02-03_07:59:13

# Crash debugging

To debug GPU crashes: `-gpucrashdebugging`

Unreal Engine 4.26.1 (I think) added Vulkan memory defrag.
It can be enabled or disabled with the `r.Vulkan.EnableDefrag` flag, e.g.:
`-dpcvars=r.Vulkan.EnableDefrag=1`

Unreal Engine 4.26 also added `-vulkanbestpractices` and ``-gpuvalidation`.
