extends RigidBody3D

var sprint_sensitivity := 1.0
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

@onready var inventory = preload("res://inventory.tscn")

var projectile = load("res://projectile.tscn")

# Called when the node enters the scene tree for the first time
func _ready() -> void: # basically setup
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().get_root().get_node("Main/CanvasLayer").add_child(inventory)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: # basically loop
	var input := Vector3.ZERO # vector 3 object
	
	# check for inventory button
	
	
	
	input.x = Input.get_axis("move_left", "move_right") # -1 for left, 1 for right, else 0
	input.z = Input.get_axis("move_forward", "move_back") # -1 for forward, 1 for back, else 0
	
	# short sprint function
	if Input.is_action_pressed("sprint"):
		sprint_sensitivity = 2.0
	else:
		sprint_sensitivity = 1.0
	
	# normalizing speed in all directions
	if input.length() > 0:
		input.normalized() # sets value to 1, so when moving diagonal, you move at the same speed
	
	apply_central_force(twist_pivot.basis * input * sprint_sensitivity * 1200.0 * delta); # multiplying by delta changes depending on framerate (decreases bugs)
	
	# basic unlocking and locking mouse movement
	if Input.is_action_just_pressed("ui_cancel"): # ui_cancel is the esc key
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	# rotates camera based on mouse movement
	twist_pivot.rotate_y(twist_input) # $ is a reference to a node
	pitch_pivot.rotate_x(pitch_input) # rotates the PitchPivot
	pitch_pivot.rotation.x = clamp( # limits the x rotation, clamp(current, min, max)
		pitch_pivot.rotation.x,
		deg_to_rad(-55),
		deg_to_rad(75)
	)
	# stops mouse movement!! no more camera gliding
	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void: # runs every time an event occurs
	if event is InputEventMouseMotion: # checks if mouse motion (the event holds data on how far the mouse has moved)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: # only moves when the mouse mode is captured
			twist_input = - event.relative.x * mouse_sensitivity # negative values so it moves in the same direction as the mouse
			pitch_input = - event.relative.y * mouse_sensitivity
