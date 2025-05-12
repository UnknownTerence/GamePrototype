extends Area3D

@export var ItemTypes : Array[ItemData] = []

var NearbyBodies : Array[InteractableItem] = []

signal OnItemPickedUp(item)

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		PickupNearestItem()

func PickupNearestItem():
	var nearestItem : InteractableItem = null
	var nearestItemDistance : float = INF

	for item in NearbyBodies:
		if (item.global_position.distance_to(global_position) < nearestItemDistance): # checks if each item in bodies is the closest (like a sorting algorithm)
			nearestItemDistance = item.global_position.distance_to(global_position)
			nearestItem = item
			
	if (nearestItem != null):
		nearestItem.queue_free()
		NearbyBodies.remove_at(NearbyBodies.find(nearestItem))
		var itemPrefab = nearestItem.scene_file_path
		for i in ItemTypes.size():
			if (ItemTypes[i].ItemModelPrefab != null and ItemTypes[i].ItemModelPrefab.resource_path == itemPrefab):
				print("Item id: " + str(i) + " Item Name: " + ItemTypes[i].ItemName)
				OnItemPickedUp.emit(ItemTypes[i])
				return
		
		printerr("Item not found")

func OnObjectEnteredArea(body: Node3D):
	if (body is InteractableItem):
		body.GainFocus()
		NearbyBodies.append(body)

func onObjectExitedArea(body: Node3D):
	if (body is InteractableItem and NearbyBodies.has(body)):
		body.LoseFocus()
		NearbyBodies.remove_at(NearbyBodies.find(body))
