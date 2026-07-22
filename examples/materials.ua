# Experimental!
~ "../lib.ua" ~ Material Mesh RenderConfig RenderMesh RenderOutput Suzanne

RC ← RenderConfig
RO ← RenderOutput

RC 500_500

Suzanne

Mesh.AddMaterials≡(Material¤¤) Gay
Mesh.AddMaterials¤Material ⧋⊂⧋÷⟜⇡⊸△◿₂⧋/+⇡20_20
⍜Mesh.Materials↻₅
°⊸Mesh.MaterialIndex⌊×₃+₁÷₃≡/+⧋⊣⊸Mesh.Triangles

⤚RenderMesh
⊸RO.GenUVs
RO.GenMaterials

×⊃RO.Get!"Light" RO.Get!"Color"
&ims
