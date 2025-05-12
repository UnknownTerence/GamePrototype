extends RigidBody3D

var rng := RandomNumberGenerator.new()

var angular_speed := 20.0
var linear_speed := 400.0
var jump := 300.0
var rotate = 0.0
var direction = Vector3()

var _isDead = false
var harvesting = false
var harvested = false
var bodies_in_area := []

var meat : MeshInstance3D
var hide : MeshInstance3D
var meatCollider : CollisionShape3D
var hideCollider : CollisionShape3D

var mat1 = preload("res://assets/materials/base.tres")
var mat2 = preload("res://assets/materials/red.tres")
var meatMat = preload("res://assets/materials/meat.tres")
var hideMat = preload("res://assets/materials/hide.tres")

@onready var OGdante := preload("res://HarvestResources/animal_meat.tscn")
@onready var OGdante2 := preload("res://HarvestResources/animal_hide.tscn")

@onready var prompt = $HarvestPrompt
@onready var prompt_area = $HarvestArea

@export var health = 3

func _ready():
	rng.randomize()
	set_new_target()
	$MeshInstance3D.set_surface_override_material(0, mat1)
	prompt_area.body_entered.connect(on_body_entered) # connects to corresponding function
	prompt_area.body_exited.connect(on_body_exited) # connects to corresponding function
	rotation.z = 0
	rotation.x = 0

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("testKey"):
		apply_central_force(Vector3(0.0, 1000.0, 0.0))
		
	rotation.x = 0
	rotation.z = 0

func set_new_target():
	# var numx = rng.randf_range(-20.0, 20.0) # generates a random number for x direction
	# var numz = rng.randf_range(-20.0, 20.0) # generates random number for z direction
	rotate = rng.randf_range(-1.0, 1.0) # random number (cw or ccw)
	direction = Vector3(0.0, rotate * angular_speed, 0.0)

func _on_timer_timeout() -> void:
	apply_central_force(Vector3(0.0, jump, 0.0))
	apply_torque(direction)
	set_new_target()
	$Timer2.start()

func _on_timer_2_timeout() -> void:
	apply_central_force(basis.z * -linear_speed)
	$Timer2.stop()

func hit() -> void:
	health -= 1
	# apply_central_force(Vector3(0.0, 1000.0, 0.0))
	# await get_tree().create_timer(0.5).timeout
	linear_speed *= 1.3
	jump *= 0.8
	if health == 0:
		_isDead = true
		$MeshInstance3D.set_surface_override_material(0, mat2)
		$Timer.stop()
		$Timer2.stop()
	# queue_free()

# harvesting prompt stuff
func on_body_entered(body: Node3D):
	if body.name == "Player":
		if _isDead and !harvested and !harvesting:
			prompt.text = "Press F to harvest"
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
		elif harvested:
			prompt.text = "Press F to take"
		bodies_in_area.append(body)
	
func on_body_exited(body: Node3D):
	if body.name == "Player":
		prompt.text = ""
		bodies_in_area.erase(body)

# when player yes
func _on_player_interact() -> void:
	if bodies_in_area.size() > 0: # there is a player in the current area
		if !harvesting and !harvested: #check if the animal is being harvested or is already harvested
			if _isDead:
				prompt.text = "Harvesting..."
				harvesting = true
				await get_tree().create_timer(2.0).timeout
				if bodies_in_area.size() > 0: # need to check again because of the timer
					prompt.text = "Harvested"
				harvesting = false
				harvested = true
				harvest_animal()

# This function will turn the animal into the quarters and hide
func harvest_animal():
	var parent = get_parent()
	var dante = OGdante.instantiate()
	var dante2 = OGdante2.instantiate()
	
	parent.add_child(dante)
	parent.add_child(dante2)
	
	dante.transform.origin = transform.origin + Vector3(1, 0, 1)
	dante2.transform.origin = transform.origin + Vector3(0, 0, 1)
	
	queue_free()
