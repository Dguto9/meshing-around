# Experimental!
~ "../lib.ua" ~ Camera Material Mesh OBJ RenderConfig RenderMesh RenderOutput RenderPreview Transform
~ "gh: Omnikar/uiua-math" ~ Dot Qqp RQuat

RC ← RenderConfig
RO ← RenderOutput

CombineRO ← (
  ◡∩RO.Depth
  ≤
  ⊙⊸∩{⊃(RO.Material‥Albedo|RO.Depth|RO.Normal|RO.Pos)}
  ⊙(°□₈♭⍉⊟)
  ∩₄⌞(⨬⊙◌◌)
  °⊸⊃(RO.Material‥Albedo|RO.Depth|RO.Normal|RO.Pos)
)

RC 500_500
°⊸RC.Camera‥Rotation Qqp RQuat×0.5 η 0_0_1 RQuat×0.3 η ¯1_0_0

°OBJ &fras "examples/assets/uvsphere.obj"
⍜Mesh.Transform‥Scale (×0.5)
□-⊸¬⤸₁⇌▽₂0.5⧋↙₃◌°img &frab "examples/assets/bricks_normal.png"
˜⍜Mesh.TextureSet⊂

↯6
gen 6 30
⟜≡(°⊸Mesh.Transform‥Position˜⊂0 -⊸¬ gen 2)
≡(°⊸Mesh.Transform‥Rotation˜RQuat 0_0_1)
≡(°⊸Mesh.Materials¤Material¤¤ ⊏⌊×⊙⊸⧻⚂Gay)

⤙≡⌟(RO.ConvertTanNormals⊸RO.ApplyTexFromSet!RO.Normal 0 ⊸RO.GenUVs⊸RO.GenPos⊸RO.GenMaterials⤚RenderMesh)

°OBJ &fras "assets/uvplane.obj"
⍜Mesh.Transform‥Scale(×1.5)
⊟⍜°□(-⊸¬) ∩(□⤸₁⇌▽₂0.5⧋↙₃◌°img&frab$"_.png") ∩⌟˜⊂ "normal" "albedo" $"examples/assets/_\_" "bricks"
Mesh.AddTexture

≡⌟°⊸Mesh.Transform‥Rotation≡RQuat η [0_0_1 1_0_0 0_1_0]
≡°⊸Mesh.Transform‥Position [0_0_¯0.5 0_1.5_0 ¯1.5_0_0]

≡⌟(RO.ApplyTexFromSet!RO.Material‥Albedo 1 ⊸RO.ConvertTanNormals⊸RO.ApplyTexFromSet!RO.Normal 0 ⊸RO.GenUVs⊸RO.GenPos⤚RenderMesh)

/CombineRO ⊂

⊸⊃RO.Pos RO.Normal
-⊸¬°⊟gen2_3_3 12
/+≡⌟₂(×⊃(↥₀¯⧋Dot÷⊸⩜⌵⧋-◌|˜÷¤¤⊙(+1˙×⩜⌵⧋-)))
×⊙RO.Material‥Albedo
&ims
