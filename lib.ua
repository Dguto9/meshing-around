# Experimental!
~ "gh: Omnikar/uiua-math" ~ Cross Dot QRot Qqp RQuat
~ "constants.ua" ~ SuzanneSTL

# Find the normal vector for a triangle
TriNorm ← ÷⊸⩜⌵Cross°⊟-¤°⊂

Det₂  ↚ /-×⇌
Proj  ↚ ˜⊞×÷⤚˙⌞∩⌞Dot
Proj₂ ↚ -+⊸∩⌟Proj

┌╶╶V
  Num          ← °0type
  Char         ← °1type
  Box          ← °2type
  Vec₂         ← ⊃(Num|°[2]△)
  Vec₃         ← ⊃(Num|°[3]△)
  Quat         ← ⊃(Num|°[4]△)
  Color        ← Vec₃
  ColorImg     ← ⊃(Num|⊃(°3⊣|°3⧻)△)
  GreyscaleImg ← ⊃(Num|°2⧻△)
└╶╶

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

  V ← °1≍"Transform"Transform~ID
└─╴
Camera ← Transform

┌─╴Material
  ~ {
    Albedo: V~Color ← White
    # Don't change this! Used for validation
    ID ← "Material"
  }
  V ← °1≍"Material"Material~ID
└─╴

┌─╴Mesh
  ~ {
    Triangles: V~Num°¤°(˜⊂3_3)△
    Normals: V~Num°¤°(˜⊂3)△ ← ¤˙⊟₃∞
    MaterialIndex: ⊃(V~Num|°1⧻△) ← ¤∞
    Transform: Transform~V ← Transform
    Materials: ≡Material~V ← [Material]
  }
  InitNormals       ← ⍥(°⊸Normals≡TriNorm⊸Triangles)≍¤˙⊟₃∞ ⊸Normals
  CalculateNormals  ← °⊸Normals≡TriNorm⊸Triangles
  InitMaterialIndex ← ⍥(°⊸MaterialIndex˜↯0 ¤⧻⊸Triangles)≍¤∞ ⊸MaterialIndex
  ApplyScale        ← °⊸Transform≈Scale↯3 1°⊸Triangles⧋×⊸⊃Transform≈Scale Triangles
  ApplyRot          ← °⊸Transform≈Rotation RQuat0˙⊟₃0°⊸⊃(Normals|Triangles) ∩⌞QRot⊸⊃(Transform≈Rotation|Normals|Triangles)
  ApplyPos          ← °⊸Transform≈Position⊚3°⊸Triangles⧋+⊸⊃Transform≈Position Triangles
  ApplyTransform    ← ApplyPos ApplyRot ApplyScale
  Rotate            ← °⊸Mesh~Transform≈Rotation Qqp⊸⊙Mesh~Transform≈Rotation

  Call ← InitMaterialIndex InitNormals New
└─╴

┌─╴RenderConfig
  ~ {
    Size: V~Vec₂ ← 100_100
    Zoom: V~Num ← 1
    Camera: Transform~V ← Transform!(°⊸Rotation Qqp∩RQuat η/3 0_0_1 2η/3 1_0_0 Transform)
    FOV: V~Num ← η
    Light: V~Vec₃ ← ÷⊸⩜⌵1_1_1
    LightColor: V~Color ← White
    AmbientColor: V~Color ← White
  }
  AspectRatio ← /÷Size
  HalfayVec   ← ÷₂+⊃(Light|Camera≈Forward)
└─╴
RC ↚ RenderConfig

┌─╴RenderOutput
  ~ {
    Albedo: V~ColorImg
    Normal: V~ColorImg
    Ambient: V~ColorImg
    Light: V~GreyscaleImg
    Depth: V~GreyscaleImg
  }
  # RenderOutput ? Size AmbientColor
  Call ← New ⊃(⊃(˜↯0|˜↯0|↯)˜⊂3|⊃(˜↯0|˜↯¯∞))
└─╴
RO ↚ RenderOutput

# Convert from World-space coordinates to View-space coordinates
# Mesh RenderConfig ? Mesh RenderConfig
WorldToView ← (
  ◡⊓Mesh~Triangles (⊃(Camera~Position|Camera~Rotation|Camera~Scale)RC~Camera)
  ⧋˜-
  ˜(QRot ⍜(↘1°⍉)¯)
  ⧋˜÷
  ⊓⌞(°⊸Mesh~Triangles|°⊸RC~Camera Transform◌)
)

# Check if a point is within a triangle
# Boolean ? 2DTriangle Point
InTri ← (
  °⊟⤚-⌞°⊂
  ∩⌞÷Det₂⟜₂(¯∩˜-∩⌟₂∩⌞Det₂)
  ×⊃(×∩≥₀|≤₁+)
)

# Rasterize a triangle
# Placement Mask ? 2DTriangle
NewDrawTri ← (
  ⊓⌊⌈⊸⊃/↧/↥
  ⧋+⇡⤚-
  ⟜(˜InTri°⍉)
)

# Rasterize a triangle
# PixelLocs ? 2DTriangle
NewNewDrawTri ← (
  ⊓⌊⌈⊸⊃/↧/↥
  ⧋+⇡⤚-
  ⟜(˜InTri°⍉)
  ˜▽⊙≠₀ ∩♭₋₁
)

# Rasterize a triangle
# Mask ? Size 2DTriangle
DrawTri ← (
  ⇌⍜°⍉˜InTri˙⊞⊟⇡
)

# Generate a depth map for a triangle
# Depths ? Size Triangle
TriDepth ← (
  ˙⊞(˜⊂0⊟)-⊸¬÷⟜⇡
  ˜⊓°⊟₃°⍉
  ∩₃⌞-
  ¯⊣Proj₂
  ⍉
)

TriWithDepth ← ⟜(×⨪)⟜×⊃(DrawTri⊙⧋↙₂|TriDepth)

# Pick the closer of two depth-value pairs
# Value Depth ? Value Depth Value Depth
CombineByDepth ← ˜(⍜-×⊙⊙⊃<↧)

# Fast render that does not output a depth map for compositing.
# Use for real-time rendering or scene previewing
# Render ? Mesh RenderConfig
RenderMeshPreview ← (
  Mesh~ApplyTransform
  Mesh~InitNormals
  Mesh~InitMaterialIndex
  WorldToView
  ◡⊓(⊃(Mesh~Triangles|Mesh~Normals)|Transform~Forward RC~Camera)
  ∩⌟(˜▽)⊙(⟜≡⌟(<0Dot))
  °⊸⊃Mesh~Triangles Mesh~Normals
  ⊃↓(
    ¤⤙˜↯0 ⋅RC~Size
  | °(-⊸¬)≡⌟Dot⊓(Mesh~Normals|RC~Light)
  | ⍏÷₃≡/+⧋⊃↘₂↙₂Mesh~Triangles)
  ∩⌞⊏
  ÷₂+₁
  ⊸∪⌟(×⊙(/↧°¤))∘
  ∧(⌝⊸⊡ ∩⌞▽ ∪⌟(≡/↧⤚>⌟⌵)∘ ˜∩⌞▽ ⊙⊸≠₀ ∩♭₋₁ ⊙×NewDrawTri)
  ⇌°⍉
)

# Full-featured renderer
# Use for real-time rendering or scene previewing
# RenderOutput ? Mesh RenderConfig
RenderMesh ← (
  Mesh~ApplyTransform
  Mesh~InitNormals
  Mesh~InitMaterialIndex
  WorldToView
  ◡⊓(⊃(Mesh~Triangles|Mesh~MaterialIndex|Mesh~Normals)|Transform~Forward RC~Camera)
  ∩₃⌟(˜▽)⊙⊙(⟜≡⌟(<0Dot))
  °⊸⊃(Mesh~Triangles|Mesh~MaterialIndex|Mesh~Normals)
  ⊃↓(
    RO⋅⊃RC~Size RC~AmbientColor
  | °(-⊸¬)≡⌟Dot⊓(Mesh~Normals|RC~Light) # Lighting values
  | Mesh~Normals                        # Normal values
  | ≡Material~Albedo ⊏Mesh~MaterialIndex⟜Mesh~Materials
  | ⊃(⧋↙₂|÷₃≡(°¤/+)⧋↘₂)Mesh~Triangles
  | ⋅RC~Size
  )
  ⊙(÷₂+₁∩₅⌞⊏◡⋅⍏)
  ×/↧
  ∧(
    NewNewDrawTri
    ⍜(⊙⊙⊙⊙⊙⊃(RO~Depth|RO~Albedo|RO~Normal|RO~Light)
    | ∩₄⌞(˜⍜⊙⬚0⊡≡⊙◌⊙¤)⊙(°□₈♭⍉⊟∩□₄)
    )
  )
  ⍜⊃(RO~Depth|RO~Albedo|RO~Normal|RO~Light)∩₄(⇌⤸1_0)
)

# Transform, shade and render an array of triangles
# Extremely slow; only use on small meshes
# Render Depth ? Mesh Scale Camera Light Size
RenderWithDepth ← (
  ˜QRot⊙(¤/Qqp˜RQuat˙⊞=⇡3)×
  ⟜(÷√3÷√≡⌟(/+˙×⟜Dot TriNorm))
  ⊙⊙(⟜(⤙×NaN˜↯0˙⊟))
  ∧(CombineByDepth×⌵∪⌞∘˜TriWithDepth)
)

# Transform, shade and render an array of triangles
# Fast; mostly-accurate depth for compositing
# Render Depth ? Mesh Scale Camera Light Size
RenderApproxDepth ← (
  ˜QRot⊙(¤/Qqp˜RQuat˙⊞=⇡3)×
  ⟜(÷√3÷√≡⌟(/+˙×⟜Dot TriNorm))
  ⤚⋅⊙∘÷₃≡/+⧋⊃↘₂↙₂
  ⊙⊙⊙(⟜(⤙×NaN˜↯0˙⊟))
  ∧(CombineByDepth⌵×∪⌞∘(⟜(×⨪)⟜×)∪⌟˜DrawTri⊙∘)
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
)

GenSTL ↚ (
  ⊙⟜⧻
  ≡˜⊂
  bytes"f32"
  ♭≡(˜⊂0_0♭)
  ⊙(bytes"u32")
  ⊂⊚80˜⊂
)

STL ← ⌅(GenSTL|DecodeSTL)

Suzanne ← °STL SuzanneSTL
