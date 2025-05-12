extends Area3D

@onready var shopMenu := preload("res://shop_menu.tscn")
var bodies_in_area := []
var menu : Control

signal inMenu() # tells the server that the player is in the menu (need to connect this to the shop Node3D then to the main script)

func on_body_entered(body : Node3D):
	if body.name == "Player":
		bodies_in_area.append(body)
		open_shop(body)

func on_body_exited(body : Node3D):
	if body.name == "Player":
		bodies_in_area.erase(body)
		close_shop(body)

func open_shop(body : Node3D):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu = shopMenu.instantiate()
	var canvas_layer = body.get_parent().get_node("CanvasLayer")
	if canvas_layer:
		canvas_layer.add_child(menu)
	else:
		print("error :c : ", body.name)

func close_shop(body : Node3D):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu.queue_free()
