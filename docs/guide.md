# A guide to using meshing-around
This document will explain the intended methods for various rendering operations.

## Importing and exporting
Both STL and Wavefront OBJ file format are supported for importing and exporting, using the `STL` and `OBJ` functions.
> The `Suzanne` constant is a nice alternative to dragging and dropping files in the pad.

## Transform
This data definition stores a vector position, a vector scale, and a quaternion rotation. By default, it's `Forward` function points in the positive Y direction.
> The coordinate system in use is right-handed and z-up (as all things should be).

## RenderConfig
`RenderConfig` stores properties such as the output resolution, the scene camera, and a directional light. It is intended that a single `RenderConfig` be used to render various meshes, which can later be composited into a single scene.
The scene camera is specified as a single `Transform` type, but the library provides the alias `Camera` so that lines like `RenderConfig~Camera≈Forward` are valid.

## Mesh
`Mesh` is one of the two larger data definitions composing this library. It stores various parameters of a mesh:
| Field | Default | Shape | Description |
| --- | --- | --- | --- |
| `Triangles` | N/A | Nx3x3 | N triplets of 3D vectors, defining a set of triangles in 3D space |
| `Normals` | Calculated from `Triangles` | Nx3 | N vectors, describing the direction each face points in 3D space |
| `UVs` | All 0s | Nx3x2 | N triplets of 2D vectors, describing where each triangle maps on a texture |
| `MaterialIndex` | All 0s | N | N integers describing which material to use for each triangle |

`Mesh` also contains a `Transform` to define the world-space position of the object, a `Materials` field which is a list of `Material` instances (described next), and a `TextureSet` field, which can be populated with an array of boxed textures for more convenient stack manipulation.

## Material
A `Material` instance holds a set of textures which define the properties of a surface. Currently, this includes the surface color, `Albedo`; the `Roughness`, which describes how glossy a surface should appear; and the `Reflectivity`, which describes how much mirror-like behaviour a surface should exhibit.

| Field | Shape |
| --- | --- |
| Albedo | MxNx3 |
| Roughness | MxN |
| Reflectivity | MxN |

In order to use a single color/value, rather than a texture, `¤ fix` the value twice.


**Next page**: [the rendering process](process.md)