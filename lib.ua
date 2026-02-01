# Experimental!
~ "gh: Omnikar/uiua-math" ~ Cross Dot QRot Qqp RQuat
~ "constants.ua" ~ SuzanneSTL

# Find the normal vector for a triangle
TriNorm ← ÷⊸⩜⌵Cross°⊟-¤°⊂

Det₂  ↚ /-×⇌
Proj  ↚ ˜⊞×÷⤚˙⌞∩⌞Dot
Proj₂ ↚ -+⊸∩⌟Proj

Num  ↚ °0type
Char ↚ °1type
Box  ↚ °2type

┌─╴Transform
  ~ {
    Position: ⊃(°0type|°[3]△) ← ⊚3
    Scale: ⊃(°0type|°[3]△) ← ↯3 1
    Rotation: ⊃(°0type|°[4]△) ← RQuat 0 ˙⊟₃ 0
    # Don't change this! Used for validation
    ID ← "Transform"
  }
└─╴

┌─╴Mesh
  ~ {
    Triangles: Num°¤°(˜⊂3_3)△
    Normals: Num°¤°(˜⊂3)△ ← ¤˙⊟₃∞
    Transform: °1≍"Transform"Transform~ID ← Transform
  }
  CalculateNormals ← ⍥(°⊸Normals≡TriNorm⊸Triangles)≍¤˙⊟₃∞ ⊸Normals
  ApplyScale       ← °⊸Transform≈Scale↯3 1°⊸Triangles⧋×⊸⊃Transform≈Scale Triangles
  ApplyRot         ← °⊸Transform≈Rotation RQuat0˙⊟₃0°⊸Triangles QRot⊸⊃Transform≈Rotation Triangles
  ApplyPos         ← °⊸Transform≈Position⊚3°⊸Triangles⧋+⊸⊃Transform≈Position Triangles
  ApplyTransform   ← ApplyPos ApplyRot ApplyScale
└─╴

┌─╴RenderConfig
  ~ {
    Size: Num ← 100
    Zoom: Num ← 1
    Camera: °1≍"Transform"Transform~ID ← Transform
    Light: ⊃(°0type|°[3]△) ← ÷⊸⩜⌵1_1_1
  }
└─╴
RC ↚ RenderConfig

┌─╴ImageDepthPair
  ~ {
    Image
    Depth
  }
└─╴
IDP ↚ ImageDepthPair

# Check if a point is within a triangle
# Boolean ? 2DTriangle Point
InTri ← (
  °⊟⤚-⌞°⊂
  ∩⌞÷Det₂⟜₂(¯∩-∩⌟₂∩⌞˜Det₂)
  ×⊃(×∩≥₀|≤₁+)
)

# Rasterize a triangle
# Mask ? Size 2DTriangle
DrawTri ← (
  ˜InTri°⍉˙⊞⊟-⊸¬÷⟜⇡
)

# Generate a depth map for a triangle
# Depths ? Size Triangle
TriDepth ← (
  ˙⊞(˜⊂0⊟)-⊸¬÷⟜⇡
  ˜⊓°⊟₃°⍉
  ∩₃⌞-
  ¯⊣Proj₂
)

TriWithDepth ← ⟜(×⨪)⟜×⊃(DrawTri⊙⧋↙₂|TriDepth)

# Pick the closer of two depth-value pairs
# Value Depth ? Value Depth Value Depth
CombineByDepth ← ˜(⍜-×⊙⊙⊃<↧)

# Fast render that does not output a depth map for compositing.
# Render ? Mesh RenderConfig
RenderMesh ← (
  Mesh~ApplyTransform
  Mesh~CalculateNormals
  ⊃↓(
    ¤⤙˜↯0 ⋅RC~Size
  | ≡⌟Dot⊓(Mesh~Normals|RC~Light)
  | ⍖÷₃≡/+⧋⊃↘₂↙₂Mesh~Triangles)
  ∩⌞⊏
  ∧(+⟜(×¬±)⌵×∪⌟˜DrawTri∘)
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
