# Experimental!
~ "gh: Omnikar/uiua-math" ~ Cross Dot Mmp Mvp QRot Qqp RQuat
~ "constants.ua" ~ SuzanneSTL

Det₂  ↚ /-×⇌
Proj  ↚ ˜⊞×÷⤚˙⌞∩⌞Dot
Proj₂ ↚ -+⊸∩⌟Proj
Inv₂  ↚ ⧋÷⊃(Det₂°⊟)⍜⇌(⤸₁⍜⌝⤸¯ 0_0)

# Find the normal vector for a triangle
# Vector ? Triangle
TriNorm ← ÷⊸⩜⌵Cross°⊟-¤°⊂

# Pick the closer of two depth-value pairs
# Value Depth ? Value Depth Value Depth
CombineByDepth ← ˜(⍜-×⊙⊙⊃<↧)

┌╶╶Validation
  Num          ← °0type
  Char         ← °1type
  Box          ← °2type
  Vec₂         ← ⊃(Num|°[2]△)
  Vec₃         ← ⊃(Num|°[3]△)
  Quat         ← ⊃(Num|°[4]△)
  Color        ← Vec₃
  ColorImg     ← ⊃(Num|⊃(°3⊣|°3⧻)△)
  AlphaImg     ← ⊃(Num|⊃(°2⊣|°3⧻)△)
  GreyscaleImg ← ⊃(Num|°2⧻△)
└╶╶
V ↚ Validation

# Transform is used to represent the translation, rotation, and scale of an object.
┌─╴Transform
  ~ {
    Position: V~Vec₃ ← ⊚3
    Scale: V~Vec₃ ← ↯3 1
    Rotation: V~Quat ← RQuat 0 ˙⊟₃ 0
    # Don't change this! Used for validation
    ID ← "Transform"
  }
  Forward ← ˜QRot 0_1_0 Rotation
  Right   ← ˜QRot 1_0_0 Rotation
  Up      ← ˜QRot 0_0_1 Rotation

  V ← °1≍"Transform"ID
└─╴
Camera ← Transform

# Materials are used to represent a particular set of shading values.
# Each field of a material contains a texture, which will be mapped to the surface of any triangle using it.
# To use a single value rather than a texture, `¤¤` the value.
┌─╴Material
  ~ {
    Albedo: V~ColorImg ← ¤¤White
    Roughness: V~GreyscaleImg ← ¤¤1
    Reflectivity: V~GreyscaleImg ← ¤¤0
    # Don't change this! Used for validation
    ID ← "Material"
  }
  V ← °1≍"Material"ID
└─╴

# A mesh represents a single object to render.
# It holds a set of triangles, their normal vectors, their UV coordinates,
# the materials to shade with, which triangles use which materials, a transform,
# and a set of textures to be moved around with the mesh.
┌─╴Mesh
  ~ {
    Triangles: V~Num°¤°(˜⊂3_3)△
    Normals: V~Num°¤°(˜⊂3)△ ← ¤˙⊟₃∞
    UVs: V~Num°¤°(˜⊂3_2)△ ← ↯1_3_2 ∞
    MaterialIndex: ⊃(V~Num|°1⧻△) ← ¤∞
    Transform: Transform~V ← Transform
    Materials: ≡Material~V ← [Material]
    TextureSet: ≡V~Box ← []
  }
  InitNormals       ← ⍥(°⊸Normals≡TriNorm⊸Triangles)≍¤˙⊟₃∞ ⊸Normals
  CalculateNormals  ← °⊸Normals≡TriNorm⊸Triangles
  InitUVs           ← ⍥(°⊸UVs ˜↯0 ˜⊂3_2 ⧻⊸Triangles)≍↯1_3_2 ∞ ⊸UVs
  InitMaterialIndex ← ⍥(°⊸MaterialIndex˜↯0 ¤⧻⊸Triangles)≍¤∞ ⊸MaterialIndex
  ApplyScale        ← °⊸Transform≈Scale↯3 1°⊸Triangles⧋×⊸⊃Transform≈Scale Triangles
  ApplyRot          ← °⊸Transform≈Rotation RQuat0˙⊟₃0°⊸⊃(Normals|Triangles) ∩⌞QRot⊸⊃(Transform≈Rotation|Normals|Triangles)
  ApplyPos          ← °⊸Transform≈Position⊚3°⊸Triangles⧋+⊸⊃Transform≈Position Triangles
  ApplyTransform    ← ApplyPos ApplyRot ApplyScale
  Rotate            ← °⊸Mesh~Transform≈Rotation Qqp⊸⊙Mesh~Transform≈Rotation

  Call ← InitUVs InitMaterialIndex InitNormals New
└─╴

# A RenderConfig defines some parameters for rendering a mesh, which aren't specific to the mesh.
# Using the same RenderConfig with multiple meshes should result in a set of renders which can be composed into a single scene, as though they were rendered from the same camera.
┌─╴RenderConfig
  ~ {
    Size: V~Vec₂ ← 100_100
    Zoom: V~Num ← 1
    Camera: Transform~V ← Transform
    FOV: V~Num ← η
    Light: V~Vec₃ ← ÷⊸⩜⌵1_0_¯1
    AmbientColor: V~Color ← Black
  }
  AspectRatio ← /÷Size
  HalfayVec   ← ÷₂+⊃(Light|Camera≈Forward)
└─╴
RC ↚ RenderConfig

┌─╴RenderOutput
  ~ {
    Index: V~GreyscaleImg
    Depth: V~GreyscaleImg
    MaterialIndex: V~GreyscaleImg
    Normal: V~ColorImg
    Light: V~GreyscaleImg
    TriCoords: V~AlphaImg
    Ambient: V~ColorImg
    UVs: V~AlphaImg ← ↯1_1_2 ∞
    Pos: V~ColorImg ← ↯1_1_3 ∞
    Albedo: V~ColorImg ← ↯1_1_3 ∞
    Roughness: V~GreyscaleImg ← ↯1_1 ∞
    Reflectivity: V~GreyscaleImg ← ↯1_1 ∞
  }
  ApplyTexture‼ ← °⊸^0^1˜⬚0⊡⟜(⌊⧋×△₂)⊙⊸⊃(UVs|^0)
  ApplyTexture! ← ApplyTexture‼^⊙◌
  GenMeshProp‼ ↚ (
    ⤚⊙(⊃TriCoords(∩⌞⬚NaN⊏Index)|∩°⍉⟜-⌞°⊂⍉^0)
    +⍉∪⌟⧋˜Mvp∘
    °⊸^1
  )
  GenUVs ← (
    GenMeshProp‼Mesh~UVs UVs
  )
  GenPos ← (
    GenMeshProp‼Mesh~Triangles Pos⊙Mesh~ApplyTransform
  )
  GenMatData ← (
    ⤚⊓(⊃MaterialIndex UVs|⍚⊃(Material~Albedo|Material~Roughness|Material~Reflectivity) Mesh~Materials)
    ⊞=⇡◡⋅⋅⧻
    ⨬NaN_NaN∘⊙¤
    ∩₃⌞(/+≡◇(⬚0⊡⌊⧋×⊸⊙△₂))
    °⊸⊃(Albedo|Roughness|Reflectivity)
  )
  ApplyTexFromSet‼ ← (
    ∪⌞∘(°□⊡)⊙⊙Mesh~TextureSet
    ˜ApplyTexture‼^0^1
  )
  ApplyTexFromSet! ← (
    ∪⌞∘(°□⊡)⊙⊙Mesh~TextureSet
    ˜ApplyTexture‼^0⊙◌
  )
  ConvertTanNormals ← (
    ⊙(⊃(⍜⍉(-⌞°⊂)Mesh~Triangles|⍜⍉(Inv₂-⌞°⊂)Mesh~UVs|Mesh~Normals)Mesh~ApplyTransform
      ÷⊸⧋(√/+˙×)≡(⊂˜Mmp))
    ⍉⧋˜Mvp Normal⟜⤚(⬚0⊏Index)
    °⊸Normal
  )
  Call ← °⊸UVs˜↯0△ ⊸TriCoords New
└─╴
RO ↚ RenderOutput

┌─╴ImageAndDepth
  ~ {Image: V~ColorImg|Depth: V~GreyscaleImg}
  Combine ← ImageAndDepth CombineByDepth ∩°ImageAndDepth
└─╴
IAD ← ImageAndDepth

# Convert from World-space coordinates to View-space coordinates
# Mesh RenderConfig ? Mesh RenderConfig
WorldToView ← (
  ◡⊓Mesh~Triangles (⊃(Camera~Position|Camera~Rotation|Camera~Scale)RC~Camera)
  ⧋˜-
  ˜(QRot ⍜(↘1°⍉)¯)
  ⧋˜÷
  ⊓⌞(°⊸Mesh~Triangles|°⊸RC~Camera Transform◌)
)

# Filter out faces by direction facing relative to camera
# Mesh ? Mesh RenderConfig
CullBackfaces ← (
  ˜⤚⊓(¯RC~Camera≈Up|⊃(Mesh~Normals|Mesh~Triangles|Mesh~UVs|Mesh~MaterialIndex))
  ∩₄⌞▽⊸≡⌞(>0Dot)
  °⊸⊃(Mesh~Normals|Mesh~Triangles|Mesh~UVs|Mesh~MaterialIndex)
)

# Check if a point is within a triangle
# Boolean ? 2DTriangle Point
InTri ← (
  °⊟⤚-⌞°⊂
  ∩⌞÷Det₂⟜₂(¯∩˜-∩⌟₂∩⌞Det₂)
  ×⊃(×∩≥₀|≤₁+)
)

# Rasterize a triangle
# PixelLocs ? 2DTriangle
DrawTri ← (
  ⊓⌊⌈⊸⊃/↧/↥
  ⧋⤙+⇡⤚-
  ⊙(⊚˜InTri°⍉)
  +°¤
)

# Fast render that does not output a depth map for compositing
# Use for real-time rendering or scene previewing
# Render ? Mesh RenderConfig
RenderMeshPreview ← (
  Mesh!(
    ApplyTransform
    InitNormals
  )
  ◡⊓(⊃(Mesh~Triangles|Mesh~Normals)|¯RC~Camera≈Up)
  ∩⌟˜▽⊙(⟜≡⌟(>0Dot))
  °⊸⊃Mesh~Triangles Mesh~Normals
  WorldToView
  ⊃↓(
    /↧⤙˜↯0 ⋅RC~Size
  | °(-⊸¬)¯⧋Dot⊓(Mesh~Normals|RC~Light)
  | ⍖÷₃≡/+⧋⊃↘₂↙₂Mesh~Triangles)
  ∩⌞⊏
  ÷₂+₁
  ∪⌟×∘
  ∧(˜⍜⊙⬚0⊡≡⊙◌⊙¤ DrawTri)
  ⇌°⍉
)

# Full-featured renderer
# Use for real-time rendering or scene previewing
# RenderOutput ? Mesh RenderConfig
RenderMesh ← (
  Mesh!(
    ApplyTransform
    InitNormals
    InitMaterialIndex
  )
  WorldToView
  ◡⊓(⊃Mesh~Triangles Mesh~Normals|⊃(RC~Camera≈Forward|/↧⤙˜↯∞ RC~Size))
  ⊃(÷₃≡(°¤/+)⧋↘₂|°(-⊸¬)⧋↙₂)
  ⟜∩₃⌟˜▽⊙⊙(°⊏≡⌟(>0Dot))
  ⊙(∪⌞∘×∩⌞⊏⍖)
  ⤚⋅(⇌°⍉∧(⍜⊙⬚0⊡≡⊙◌¤ ⊙DrawTri))
  ⊙⊙⊃↓(
  | ↯⋅⊃(˜⊂3RC~Size|RC~AmbientColor)
  | ⍜(°⊂⍉)⟜(Inv₂-⌞)×⊓(°(-⊸¬)⧋↙₂Mesh~Triangles|/↧RC~Size) # UVs
  | °(-⊸¬)¯⧋Dot⊓(Mesh~Normals|RC~Light)                  # Lighting
  | Mesh~Normals                                         # Normal
  | Mesh~MaterialIndex                                   # Albedo
  )
  ⟜⊓⌞(
    ⬚∞⊏ | ⬚NaN⊏ | ⬚0⊏ | ⬚0⊏
  | ⇌⤸₁⍉⧋˜Mvp⊙(⤸0_1_3_2⍉)˜-⇡⊸△₂°⊂⤸₂⬚NaN⊏⍉⇌
  )
  RO
)

DecodeBinSTL ↚ (
  ↘84
  ▽<48◿50⇡⊸⧻
  ↯˜⊂⟜÷4⊸⧻
  ⌝bytes"f32"
)

DecodeAsciiSTL ↚ (
  ⍣(°1⊸type|°utf₈)
  ⊜□×⊸∩⌟≠@\n@ 
  ⍚(⍣(1⋕)(0∘))
  ≡°□▽≡°□
)

DecodeSTL ↚ (
  ⍣(DecodeAsciiSTL|DecodeBinSTL)
  ↯˜⊂4_3÷12⊸⧻
  ⍜⍉(⍉°⊂)
  ⤙⊙◌
  Mesh!(˜°⊸Normals Mesh)
)

GenSTL ↚ (
  ⊃(Mesh~Triangles|Mesh~Normals)
  ⊙⟜⧻
  ≡˜⊂
  bytes"f32"
  ♭≡(˜⊂0_0♭)
  ⊙(bytes"u32")
  ⊂⊚80˜⊂
)

DecodeOBJ ↚ (
  ⊜(□⊜□⊸≠@ )⊸≠@\n
  ≡◇⊃(∩₄⌟(/↧=)"v " "vt" "vn" "f " ⬚@ ↙₂°□°¤↙₁|□↘₁)
  ∩₄⌟▽
  ∩₃⋕⊙⊙⊙(⊙⊙⧋⊢°⊟₃°⍉≡◇≡◇⊜(-₁⋕)⊸≠@/)
  °□₆♭⍉˜⊟∩□₃
  ∩₃⊏
  Mesh!(˜°⊸Normals˜°⊸UVs Mesh)
)

GenOBJ ↚ (
  ⊃(Mesh~Triangles|Mesh~UVs|Mesh~Normals)
  ∩₃(⊸≡⌟˜⨂⟜(◴♭₂))
  °□₆♭⇌⍉⊟₃∩₃□₂
  ∩₃⍚/$"_ _"
  ⊓(⍚⌞⊂"v "|⍚⌞⊂"vt "|⍚⌞⊂"vn ")
  ∩₃/$"_\n_"
  ⊙⊙⊙(/$"_\n_"⍚⌞⊂"f "⍚/$"_ _"⍚₁/$"_/_"+₁⍉⊟₃⊙⊙(⍉˙⊟₃))
  "# Meshing Around\n# https://github.com/Dguto9/meshing-around"
  /$"_\n_" □₅
)

# Import an STL file as a Mesh. STL files do not contain UV coordinates.
STL ← ⌅(GenSTL|DecodeSTL)
# Import an OBJ file as a Mesh
OBJ ← ⌅(GenOBJ|DecodeOBJ)

Suzanne ← °STL SuzanneSTL
