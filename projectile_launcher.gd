extends Node3D

const PROJECTILE = preload("res://projectile.tscn")

@onready var timer: Timer = $Timer
@onready var drawback := $DrawTime
@onready var speed = 0.1

var is_drawing := false
var draw_start_time := 0.0
var horace := false

signal power_changed(power: float)
signal camera_shake(intensity: float)

# chatgpt code 😢
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		is_drawing = true
		draw_start_time = Time.get_ticks_msec() / 1000.0  # current time in seconds
		drawback.stop()
		drawback.start()
	
	# my code
	if horace or !is_drawing:
		_update_power(0)
		var fov = get_parent().fov
		fov += 3
		fov = clamp(fov, 50, 75)
		get_parent().set_fov(fov)
	elif Input.is_action_pressed("click"):
		var power = Time.get_ticks_msec() / 1000.0 - draw_start_time
		_update_power(clamp(power, 0, 1.5))
		var fov = get_parent().fov
		fov -= 0.3
		fov = clamp(fov, 50, 75)
		get_parent().set_fov(fov)
		_update_camera_shake(power)

	if Input.is_action_just_released("click") and is_drawing or horace:
		drawback.stop()
		horace = false
		is_drawing = false
		var held_time = (Time.get_ticks_msec() / 1000.0) - draw_start_time
		held_time = clamp(held_time, 0, 1.5)  # Clamp to safe range
		if held_time > 0.5:
			var attack = PROJECTILE.instantiate()
			if attack and global_transform.origin.is_finite():
				get_tree().get_root().add_child(attack)  # Or whatever parent makes sense
				attack.global_transform = global_transform
				attack._set_speed(held_time)
			else:
				print("Invalid transform or projectile")
	
	
	#if timer.is_stopped():
		#if Input.is_action_just_pressed("click"):
			#timer.start(0)
			#var attack = PROJECTILE.instantiate()
			#add_child(attack)
			#attack.global_transform = global_transform

func _fire_arrow():
	horace = true

func _update_power(value):
	emit_signal("power_changed", value)

func _update_camera_shake(intensity: float):
	emit_signal("camera_shake", intensity)
