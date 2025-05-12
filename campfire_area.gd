extends Area3D

var bodiesInArea := []
var inventory : Array[InventorySlot]
var index : int = -1

@onready var prompt := $"../Prompt"
@export var cookedMeat : ItemData

signal playerCook(campfire : Area3D)
signal updateInventory(data : ItemData, slotID : int)

func onPlayerEntered(body : Node3D):
	if body.name == "Player":
		bodiesInArea.append(body)
		prompt.text = "Press F to Cook"

func onPlayerExited(body : Node3D):
	if body.name == "Player":
		bodiesInArea.erase(body)
		prompt.text = ""

func onPlayerInteract():
	if bodiesInArea.size() > 0:
		prompt.text = "COOKINGGGG..."
		await get_tree().create_timer(2.0).timeout
		playerCook.emit(self)
		prompt.text = "Press F to Cook"

func cooking():
	for slot in inventory: # searches in each slot
		if slot.SlotData != null:
			if slot.SlotData.ItemName == "Meat": # checks if the player has meat
				index = slot.InventorySlotID # set the index that the campfire will take and make into cooked meat
				print(index)
				updateInventory.emit(cookedMeat, index, 1)
				break
	


# we need invventory data, so use 
func getInventoryData(inventoryData : Array[InventorySlot]):
	inventory = inventoryData
	print("heheheaw")
