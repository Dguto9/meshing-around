# Generating maps in meshing-around

`meshing-around` provides methods for generating and modifying the many maps described in the previous page.

## RenderOutput
The `RenderOutput` data definition is used to store the various maps used for rendering. It has the following fields:

| Map | Shape |\|| Map | Shape |
| --- | --- |-| --- | --- |
| Index | MxN |\|| TriCoords | MxNx2 |
| Depth | MxN |\|| UVs | MxNx2 |
| MaterialIndex | MxN |\|| Albedo | MxNx3 |
| Normal | MxNx3 |\|| Roughness | MxN |
| Light | MxN |\|| Reflectivity | MxN |

At different points througout rendering, different combinations of these maps may be present.

## RenderMesh
The `RenderMesh` function is the central function in this library. It takes in a `Mesh` and `RenderConfig` as inputs, and outputs a partially-populated `RenderOutput`. In particular, it fills in the `Index`, `Depth`, `MaterialIndex`, `Normal`, `Light`, and `TriCoords` fields. With these maps alone, it is possible to obtain a decent rendered output. 

One option, for example, is to simply use the `Light` map as output, as it already looks like a simple shaded 3D render. In fact, since this is such a light-weight option, the function `RenderPreview` does just this, and works at nearly 20 FPS at 500x500 resolution, which is useful for camera positioning in tandem with [Iris](https://github.com/Marcos-cat/iris).

## RenderOutput methods
These functions are within the `RenderOutput` module.
### GenUVs
This function takes in a `RenderOutput` and a `Mesh` and outputs a `RenderOutput` with the `UVs` field populated. It requires that the `RenderOutput` has `Index` and `TriCoords` maps, and that the `Mesh` has `UVs`.
### GenMaterials
This function takes in a `RenderOutput` and a `Mesh` and outputs a `RenderOutput` with the `Albedo`, `Roughness`, and `Reflectivity` fields populated. This requires that the `RenderOutput` has `MaterialIndex` and that the `Mesh` has corresponding `Materials`. 

`GenUVs` must be called prior to this function if the `Materials` contain textures, as the texturing operation requires a UV map. If the `Materials` only contain doubly-`¤ fix`ed values, `GenMaterials` will work without UVs.

### ApplyTexture
The `ApplyTexture` macros provide a less expensive alternative to using the `GenMaterials` pipeline for wrapping textures around a mesh, particularly if only a single texture is being used for the every triangle in the mesh. The dyadic version, `ApplyTexture!!` takes in first a getter function (eg. `Albedo`) determining which field of `RenderOuput` to place the mapped texture in, and second a dyadic to determine how to combine the new map with the map existing at that field, assuming the new map is the first argument.

`ApplyTexture!` provides a convenient interface for forgoing specification of a combination function, and instead replaces the map entirely. Internally, this just calls the dyadic version with `⊙◌` (`dip pop`) as the combining function.

For both of these modifiers, the first argument to the resulting function is the texture as an image, and the second a `RenderOutput` with a populated `UVs` field.

It is hard, though, to move a bunch of textures around alongside `Mesh`es and `RenderOutput`s in order to use this pipeline!

### ApplyTextureFromSet
For that reason, as it may be recalled, `Mesh`es have a `TextureSet` field, allowing them to contain a number of boxed textures.
To use this, the `ApplyTextureFromSet` macros exist, taking in the same functions as the previous `ApplyTexture` ones. The difference is, resulting functions from these take in first an index determining which texture to use from the `TextureSet`, then the `RenderOutput`, then the `Mesh`.

## What next?
After using some selection of these functions, the `RenderOutput` should contain various maps describing, for each camera pixel, a bunch of different properties describing material, lighting, and even object shape. The next steps involve combining these maps into a single, shaded output.

**Next page**: [using the output](using.md)