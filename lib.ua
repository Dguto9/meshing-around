# Experimental!
~ "gh: Omnikar/uiua-math" ~ Cross Dot QRot Qqp RQuat

# Find the normal vector for a triangle
TriNorm ← Cross°⊟-¤°⊂

Det₂  ← /-×⇌
Proj  ← ˜⊞×÷⤚˙⌞∩⌞Dot
Proj₂ ← -+⊸∩⌟Proj

# Check if a point is within a triangle
# Boolean ? Triangle Point
InTri ← (
  °⊟⤚-⌞°⊂
  ∩⌞÷Det₂⟜₂(¯∩-∩⌟₂∩⌞˜Det₂)
  ×⊃(×∩>₀|<₁+)
)

# Rasterize a triangle
# Mask ? Size Triangle
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

# Transform, shade and render an array of triangles
# Use if you won't need depth information
# Render ? Mesh Scale Camera Light Size
RenderMesh ← (
  ˜QRot⊙(¤/Qqp˜RQuat˙⊞=⇡3)×
  ⟜(÷√3÷√≡⌟(/+˙×⟜Dot TriNorm))
  ∩⌞⊏⍖÷₃≡/+⧋⊃↘₂↙₂
  ⊙⊙(¤⤙˜↯0)
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
