extends ColorRect

func _on_projectile_launcher_power_changed(power: float) -> void:
	var height = get_viewport().size.y
	var sizeHeight = height * 0.4
	var positionHeight = height * 0.2
	size.y = sizeHeight * power # if this is 0
	position.y = positionHeight + (sizeHeight * (1.5 - power)) # then this is 216 + size.y at max
	# print("height: " , height , " | size: " , sizeHeight , " | position: " , positionHeight)
	
	#size.y = 432 * power # if this is 0
	#position.y = 216 + (432 * (1.5 - power)) # then this is 216 + size.y at max
