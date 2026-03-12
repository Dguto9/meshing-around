# Render process
This page is dedicated mainly to an explanation of the render process and the different maps which it provides.

## Mesh preparation
The first operations performed by the render functions prepare the triangles of the mesh to be displayed on the screen. The main steps of preparation include:
- Applying mesh transforms
    - The actual triangle coordinates are translated, scaled, and rotated, according to the `Mesh`'s `Transform` field.
- Transforming the triangles into view-space
    - The transformations described in the `Camera` field of `RenderConfig` are applied to the triangle coordinates in reverse, simulating the positioning of a camera in space.
- Backface culling
    - Triangles which face away from the `Camera` are removed from the render.
- Projection to the camera plane
    - Triangles are split into their first two coordinates, which define their screen-space position, and their depth away from the camera (the last coordinate).
- Depth resolution
    - Triangles are sorted based on their depth, such that ones further away are drawn first.
- Image-space scaling
    - The triangle coordinates are finally scaled such that `(-1, 1)`<sup>2</sup> gets mapped to `(0, m)×(0, n)`, where m, n determine the output resolution.

## What is a map?
In this document, a map refers to an image describing some property (color, depth, etc.) from the perspective of the camera. Opposedly, a texture will refer to an image which is sampled from or applied to the surface of a mesh during the rendering process, but does not visually take the shape of the mesh. During the rendering process, various maps are generated and modified, and later combined into a single image output.

## Index map
At the core of the rendering functions `meshing-around` supplies is the generation of the index map. This takes the set of triangles, sorted by closeness to the camera, and blits their index to an image, wherever the triangle is visible. Anywhere in the image where no triangle is present is valued at `∞`, for `⬚ fill` purposes.\
![Index map of Suzanne](assets/indexmap.png)
> For the purpose of visualization, the indices here are divided to fit between 0 and 1. The index map will contain natural values between 0 and the number of triangles in the mesh.

The index map becomes useful when we want to place per-triangle data on each rendered triangle. To do this, we make use of `⊏ select` which substitutes per-triangle data into every location of the image by index. By using various `⬚ fill` values, we can also choose the background of each map.

Examples of this per-triangle data, mapped to the frame by the index map, are `Depth`, `MaterialIndex`, `Normal`, and `Light` values—which will be explored below.

## Depth, normal, light, and material index maps
| Map | Description | Image | Map | Description | Image |
| --- | --- | --- | --- | --- | --- |
| Depth | How far from the camera is each pixel? | ![alt text](assets/depthmap.png) | Normal | What spatial direction does each pixel point? | ![alt text](assets/normalmap.png) |
| Light | How much is each pixel pointing toward the scene light? | ![alt text](assets/lightmap.png) | Material Index | What material should each pixel use? | ![alt text](assets/materialind.png) |

Having these maps generated is already a great leap in the right direction. With a normal map, lighting by various lights can be determined. With the material index map, colors from each material can be selected to make the mesh colorful. Those results can even be multiplied together to get both shading and triangle colors!

## Relative coordinates (TriCoords)
The final map generated within the standard rendering process is significantly more complicated than the per-triangle data, but it opens up the door to determining per-pixel data for the render. This map provides two values for each pixel, which describe their position within the triangle. More specifically, it maps each pixel to its coordinate in the basis determined by the vectors pointing from the triangle's first vertex to the other two.\
![alt text](assets/relcoords.png)\
This map, alongside the index map, allows pixel values to be determined based on other triangles. This is particularly useful for texture coordinates. This, though, concludes the happenings within the standard rendering function, `RenderMesh`, as operations like generating texture coordinates are expensive, and therefore are optional to users.

## Generating texture coordinates
Most modern 3D file formats contain texture coordinate data alonside the triangle data. That is—each vertex is also paired with a corresponding vertex in 2D texture space, defining some "unwrapping" of the object. This texture space is often referred to as "UV" space, since it creates a parameterization under the texture coordinate basis of the right-pointing and up-pointing vectors named U and V, respectively. Below is a view of Suzanne's UV parameterization, shown in Blender.
![alt text](assets/blenderuvs.png)
> This image shows quads, since triangulation is done as a step in the export process. `meshing-around` supports only triangle meshes.

By using the previously determined relative coordinates, each individual pixel of a render can be remapped to a position within each UV-space triangle, through a few linear transformations. This provides a map of what area of a texture each pixel of a render should sample from, as a value between 0 and 1 in each axis.\
![alt text](assets/uvs.png)\
This map can be used to `⊡ pick` values from a texture once scaled by the texture's shape, in order to "apply" the texture to the mesh. It is required to use a `⬚ fill` value to set the background.

## Material maps
Once a texture coordinate map and a material index map are present, a set of material maps can be generated, matching the textures stored in the `Material` data definition. Using the process described in the previous section, each of the material textures is applied to the triangles assigned to it, and then these are combined into single `Albedo`, `Roughness`, and `Reflectivity` maps.

**Next page**: [render functions](functions.md)