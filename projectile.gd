extends RayCast3D

@export var speed := 50.0
@export var gravity := -9.8

@onready var remote_transform := RemoteTransform3D.new()

var velocity := Vector3()

func _ready():
	velocity = -global_transform.basis.z * speed
	# target_position = Vector3(0,0,-100)

func _physics_process(delta: float) -> void:
	#velocity.y += gravity * delta
	# position += global_basis * velocity * delta
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	
	#var local_movement = Vector3(0, 0, -speed * delta)
	#var global_movement = global_transform.basis * (local_movement + Vector3(0, velocity.y * delta, 0))
	#global_position += global_movement
	rotation.x -= deg_to_rad(0.2)
	rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	#target_position = local_movement.normalized() * speed * delta
	
	force_raycast_update()
	var collider = get_collider()
	if is_colliding():
		global_position = get_collision_point()
		set_physics_process(false) # determines if the process is running (if collided, the loop will stop)
		collider.add_child(remote_transform)
		remote_transform.global_transform = global_transform
		remote_transform.remote_path = remote_transform.get_path_to(self)
		remote_transform.tree_exited.connect(cleanup) # tree_exited is when the parent node leaves the scene (gets deleted), .connect connects it to the cleanup function
		#if collider.name == "MovingWall":
		if collider.is_in_group("animal"):
			collider.hit()
	
func _set_speed(newSpeed: float):
	speed = 50.0 * newSpeed
	
func cleanup() -> void:
	queue_free() # deletes the projectile when the timer is up
