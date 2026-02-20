# Experimental!
~ "gh: Omnikar/uiua-math" ~ Cross Dot MInv Mvp QRot Qqp RQuat
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
  Forward ← ˜QRot 0_0_¯1 Rotation
  Right   ← ˜QRot 1_0_0 Rotation
  Up      ← ˜QRot 0_1_0 Rotation

  V ← °1≍"Transform"ID
└─╴
Camera ← Transform

┌─╴Material
  ~ {
    Albedo: V~Color ← White
    # Don't change this! Used for validation
    ID ← "Material"
  }
  V ← °1≍"Material"ID
└─╴

┌─╴Mesh
  ~ {
    Triangles: V~Num°¤°(˜⊂3_3)△
    Normals: V~Num°¤°(˜⊂3)△ ← ¤˙⊟₃∞
    UVs: V~Num°¤°(˜⊂3_2)△ ← ↯1_3_2 ∞
    MaterialIndex: ⊃(V~Num|°1⧻△) ← ¤∞
    Transform: Transform~V ← Transform
    Materials: ≡Material~V ← [Material]
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

┌─╴RenderConfig
  ~ {
    Size: V~Vec₂ ← 100_100
    Zoom: V~Num ← 1
    Camera: Transform~V ← Transform
    FOV: V~Num ← η
    Light: V~Vec₃ ← ÷⊸⩜⌵1_0_¯1
    LightColor: V~Color ← White
    AmbientColor: V~Color ← Black
  }
  AspectRatio ← /÷Size
  HalfayVec   ← ÷₂+⊃(Light|Camera≈Forward)
└─╴
RC ↚ RenderConfig

┌─╴RenderOutput
  ~ {
    Indices: V~GreyscaleImg
    Depth: V~GreyscaleImg
    Albedo: V~ColorImg
    Normal: V~ColorImg
    Light: V~GreyscaleImg
    TriCoords
    Ambient: V~ColorImg
  }
  # RenderOutput ? Size AmbientColor
  # Call ← New ⊃(⊃(˜↯0|˜↯0|↯)˜⊂3|⊃(˜↯0|˜↯¯∞))
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

# Filter out faces by direction facing relative to camera
# Mesh ? Mesh RenderConfig
CullBackfaces ← (
  ⤚⊓(⊃(Mesh~Triangles|Mesh~MaterialIndex|Mesh~Normals)|Transform~Forward RC~Camera)
  ∩₃⌟(˜▽)⊙⊙(⟜≡⌟(>0Dot))
  °⊸⊃(Mesh~Triangles|Mesh~MaterialIndex|Mesh~Normals)
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

# Fast render that does not output a depth map for compositing
# Use for real-time rendering or scene previewing
# Render ? Mesh RenderConfig
RenderMeshPreview ← (
  Mesh~ApplyTransform
  Mesh~InitNormals
  Mesh~InitMaterialIndex
  ◡⊓(⊃(Mesh~Triangles|Mesh~Normals)|Transform~Forward RC~Camera)
  ∩⌟(˜▽)⊙(⟜≡⌟(>0Dot))
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
  Mesh~ApplyTransform
  Mesh~InitNormals
  Mesh~InitMaterialIndex
  ⊸CullBackfaces
  WorldToView
  ◡⊓(⊃(÷₃≡(°¤/+)⧋↘₂|°(-⊸¬)⧋↙₂)Mesh~Triangles|/↧⤙˜↯∞ RC~Size)
  ⟜(⊙×⟜⊏⍖)
  ⤚⋅(⇌°⍉∧(⍜⊙⬚0⊡≡⊙◌¤ ⊙DrawTri))
  ⊙⊙⊃↓(
  | ↯⋅⊃(˜⊂3RC~Size|RC~AmbientColor)
    # | °⍉⊂⟜(⧋≡MInv-⌞)°⊂⍉×⊓(°(-⊸¬)⧋↙₂Mesh~Triangles|/↧RC~Size)
  | ≡⊢×⊓(°(-⊸¬)⧋↙₂Mesh~Triangles|/↧RC~Size)
  | °(-⊸¬)¯⧋Dot⊓(Mesh~Normals|RC~Light)                 # Lighting
  | Mesh~Normals                                        # Normal
  | ≡Material~Albedo ⊏Mesh~MaterialIndex⟜Mesh~Materials # Albedo
  )
  # ⟜⊓⌞(⬚∞⊏|⬚0⊏|⬚0⊏|⬚0⊏|⧋˜Mvp?˜-⇡↙₂⊸△⊙(⤸1_2)°⊂⤸₂⬚∞⊏)∩₅⌞⊙∘
  ⟜⊓⌞(⬚∞⊏|⬚0⊏|⬚0⊏|⬚0⊏|˜-⇡⊸△₂⬚NaN⊏⍉⇌)∩₅⌞⊙∘
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
  ≡◇⊃(∩₄⌟(/↧=)"v " "vt" "vn" "f " ⬚@ ↙₂°□°¤↙₁)(□↘₁)
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

STL ← ⌅(GenSTL|DecodeSTL)
OBJ ← ⌅(GenOBJ|DecodeOBJ)

Suzanne ← °STL SuzanneSTL
