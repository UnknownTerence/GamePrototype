extends Node3D

var rng := RandomNumberGenerator.new()

@onready var timer := $Timer
@onready var animal := preload("res://moving_wall.tscn")
@onready var player := $PlayerNode
@onready var playerInventory : Control
@onready var terrain := $TerrainGeneration
@onready var tree := preload("res://tree.tscn")
@onready var campfire := preload("res://campfire.tscn")
@onready var bed := preload("res://bed.tscn")

var numOfAnimals : int
var animals := []
var campfireCount : int = 0
var bedCount : int = 0

func _ready() -> void:
	player.createCampfire.connect(spawnCampfire)
	player.createBed.connect(spawnBed)
	playerInventory = player.get_node("InventoryUI")
	
	# get_node("/root/Shop/CanvasLayer/ShopMenu")
	rng.randomize()
	generateAnimals()
	var treeSlots = []
	for y in range(200):
		var row = []
		for x in range(200):
			row.append(false)
		treeSlots.append(row)
		
	for i in range(700):
		var x = rng.randi_range(-100, 100)
		var z = rng.randi_range(-100, 100)
		var y = terrain.get_noise_y(x, z)
		
		while abs(x) < 10 and abs(z) < 10:
			x = rng.randi_range(-100, 100)
			z = rng.randi_range(-100, 100)
			y = terrain.get_noise_y(x, z)
		if !treeSlots[z][x]:
			var yippie = tree.instantiate()
			yippie.transform.origin = Vector3(x, y, z)
			add_child(yippie)
			treeSlots[z][x] = true
				

func onPlayerCook(campfire : Area3D):
	campfire.getInventoryData(playerInventory.getInventoryData())
	campfire.cooking()
	print("khfukasjf ui4siof jos84fj ")
	

func onPlayerSleep():
	for chickens in animals:
		if is_instance_valid(chickens): # checks if the node has not been queue_free()d
			chickens.queue_free()
	animals.clear()
	
	generateAnimals()
	timer.start()

# animal instantiation
func _on_timer_timeout() -> void:
	if numOfAnimals > 0:
		var x = rng.randf_range(-100.0, 100.0)
		var z = rng.randf_range(-100.0, 100.0)
		var y = terrain.get_noise_y(x,z)
		var bob = animal.instantiate()
		player.interact.connect(bob._on_player_interact)
		get_tree().current_scene.add_child(bob)
		bob.global_transform.origin = Vector3(x, y, z)
		numOfAnimals -= 1
		animals.append(bob)
	else:
		timer.stop()

func spawnCampfire(pos : Vector3, facing : Vector3):
	if campfireCount < 1:
		var horace = campfire.instantiate()
		pos.y = terrain.get_noise_y(pos.x, pos.z)
		add_child(horace)
		horace.global_position = pos # + facing * 2.0
		
		var dante = horace.get_node("Area3D")
		player.interact.connect(dante.onPlayerInteract)
		dante.playerCook.connect(self.onPlayerCook)
		dante.updateInventory.connect(playerInventory.updateInventoryData)
		campfireCount += 1
	else:
		var canvasLayer = player.get_node("CanvasLayer")
		var label = Label.new()
		label.anchor_left = 0.5
		label.anchor_top = 0.5
		label.anchor_bottom = 0.5
		label.anchor_right = 0.5
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		label.grow_vertical =Control.GROW_DIRECTION_BOTH
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		var settings := LabelSettings.new()
		settings.font_size = 50
		label.label_settings = settings
		label.text = "You can only have one campfire"
		canvasLayer.add_child(label)
		await get_tree().create_timer(2.0).timeout
		label.queue_free()

func spawnBed(pos : Vector3, facing : Vector3):
	if bedCount < 1:
		var horace = bed.instantiate()
		pos.y = terrain.get_noise_y(pos.x, pos.z)
		add_child(horace)
		horace.global_position = pos # + facing * 2.0
		
		var dante = horace.get_node("Area3D")
		player.interact.connect(dante.onPlayerInteract)
		dante.playerSleep.connect(self.onPlayerSleep)
		bedCount += 1
	else:
		var canvasLayer = player.get_node("CanvasLayer")
		var label = Label.new()
		label.anchor_left = 0.5
		label.anchor_top = 0.5
		label.anchor_bottom = 0.5
		label.anchor_right = 0.5
		label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		label.grow_vertical =Control.GROW_DIRECTION_BOTH
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		var settings := LabelSettings.new()
		settings.font_size = 50
		label.label_settings = settings
		label.text = "You can only have one bed"
		canvasLayer.add_child(label)
		await get_tree().create_timer(2.0).timeout
		label.queue_free()

func generateAnimals():
	numOfAnimals = rng.randi_range(5, 16)
	print("num of animals: ", numOfAnimals)
