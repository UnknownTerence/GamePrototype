extends Node3D

@onready var inventory = preload("res://inventory.tscn").instantiate()
@onready var player = $Player
@onready var camera = $Player/TwistPivot/PitchPivot/Camera3D
@onready var moneyLabel = $CanvasLayer/Money

@export var money : int = 0

signal interact()
signal createCampfire(pos : Vector3, facing : Vector3)
signal createBed(pos : Vector3)

func _ready():
	pass
	# var node = get_node("/root/CanvasLayer/ShopMenu")
	#get_node("CanvasLayer").add_child(inventory)
	
func _process(delta: float) -> void:
	# Inventory
	#if Input.is_action_just_pressed("inventory"):
	#	if inventory.visible:
	#		inventory.visible = false
	#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#	else:
	#		inventory.visible = true
	#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	updateMoney()
	# Harvesting
	if Input.is_action_just_pressed("interact"):
		emit_signal("interact")
	
	# Spawn campfire
	if Input.is_action_just_pressed("campfire"):
		createCampfire.emit(getPos(), camera.global_transform.basis.z.normalized())
	
	#Spawn bed
	if Input.is_action_just_pressed("bed"):
		createBed.emit(getPos(), camera.global_transform.basis.z.normalized())

func getMoney() -> int:
	return money;

# add or subtract the players money (for buying and selling)
# true = buying, false = selling (or I can just do negative values and positive values)
func setMoney(amt : int, buying : bool):
	if buying:
		pass
	else:
		money += amt
	updateMoney()

# update the label
func updateMoney():
	moneyLabel.text = "Money: " + str(money)

func getPos() -> Vector3:
	return player.global_position
