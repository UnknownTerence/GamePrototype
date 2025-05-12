extends Node3D

class_name InteractableItem

@export var ItemHighlightMesh : MeshInstance3D
@export var ItemPrompt : Label3D

func GainFocus():
	ItemHighlightMesh.visible = true
	ItemPrompt.visible = true
	ItemPrompt.text = "Press F to interact"

func LoseFocus():
	ItemHighlightMesh.visible = false
	ItemPrompt.visible = false
