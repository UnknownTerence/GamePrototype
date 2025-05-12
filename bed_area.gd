extends Area3D

var bodiesInArea := []

@onready var prompt := $"../Prompt"

signal playerSleep()

func onPlayerEntered(body : Node3D):
	if body.name == "Player":
		bodiesInArea.append(body)
		prompt.text = "Press F to Sleep"

func onPlayerExited(body : Node3D):
	if body.name == "Player":
		bodiesInArea.erase(body)
		prompt.text = ""

func onPlayerInteract():
	if bodiesInArea.size() > 0:
		prompt.text = "Sleeping..."
		await get_tree().create_timer(2.0).timeout
		playerSleep.emit()
		prompt.text = "Press F to Sleep"
