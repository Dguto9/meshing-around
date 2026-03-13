# Using the rendered maps

## Depth resolution
One `RenderOutput` is created for each `Mesh` rendered—so how can multiple meshes be rendered in the same scene? This is handled by *depth resolution*, which combines maps based on each pixel's distance from the camera (as determined by the `Depth` map). Closer pixels of one map overwrite further pixels of another.

## Shading
Shading (technically, "fragment shading" in particular) takes the various maps and algorithmically determines the value at each pixel based on the corresponding values in each `RenderOutput` map. This may include combination of lighting with albedo, or calculation of specular highlights based on normals.

## The forward vs. deferred decision
A key difference in rendering pipelines which you may have heard of is the choice between forward rendering and deferred rendering. The decision really boils down to which of two steps come first: depth resolution and shading. Each has benefits and deficiencies.

In forward rendering, each mesh is shaded individually, and all of these shaded renders are combined through the depth map after. This means that many pixels are being shaded, and later thrown out for being obscured.

In deferred rendering, the shading operation is "deferred" until after depth resolution. This means that every map for every mesh in the scene is composed until there's a single one of each for the entire scene. Then, shading happens for the entire scene in one sweep. This method makes it difficult to 

Forward rendering makes object transparency and anti-aliasing far easier, but since shading calculations must be made for pixels which will later be obscured, is less efficient when the shading calculations are expensive. For example, in a scene with many lights, forward rendering must perform lighting calculations for every light, for every object in the scene. Deferred rendering's difficulty, on the other hand, scales only with number of lights.

Deferred rendering also provides the same maps needed by some post-processes like screen-space reflections.

## Shading, continued
`meshing-around` currently does not provide any functions for turning a RenderOutput directly into a shaded output; that's for you to create! For an easy and good-looking option, though, multiplying `Light` and `Albedo` looks good. Here are some things you might want to try implementing:
- [Phong reflection model](https://en.wikipedia.org/wiki/Phong_reflection_model), or easier, the [Blinn-Phong shading model](https://en.wikipedia.org/wiki/Blinn%E2%80%93Phong_reflection_model)
- Screen space reflection (this would probably be quite difficult)
- Hard shadows, by rendering the scene from the perspective of a light source
- Baking static light sources into a texture for faster rendering
> I've been too scared to try the bottom three, as of yet.

If you make a cool shader that seems generally useful, I might add it to the library (with credit, of course)! Just make a PR.

## Other things
- How [smooth shading](smooth.md) can currently be achieved
- [Exporting models from blender](blender.md), for use in `meshing-around`
- How to [contribute](contribute.md)

