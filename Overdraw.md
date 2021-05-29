2021-05-29_08:23:27

# Overdraw

 Relates to transparency and opacity.
 When the GPU is drawing fragments that are empty.
 Dead/invisible parts of a triangle.
 Wasted calculations, costs performance.
 Common with foliage, because of many overlapping planes simulating a volume.
 Reduce overdraw by shaping your mesh to match the non-transparent parts of the texture.
 The mesh should hug the outline.
 This is often a gain even if more vertices are requires, since there are often way more fragments than vertices.
 
 Level Editor > Viewport > View Mode > Optimization Viewmodes > Shader Complexity.
 