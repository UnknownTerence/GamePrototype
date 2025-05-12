extends Control

# first menu you see
@onready var mainMenu = $Panel/MarginContainer/CenterContainer/MenuOptions
@onready var buyBtn = $Panel/MarginContainer/CenterContainer/MenuOptions/BuyBtn
@onready var sellBtn = $Panel/MarginContainer/CenterContainer/MenuOptions/SellBtn

var label : Label

# buy menu
@onready var buyMenu = $Panel/MarginContainer/CenterContainer/BuyMenu

# sell menu
@onready var sellMenu = $Panel/MarginContainer/CenterContainer/SellMenu

var money : int
var ItemSlotsCount : int = 20
@onready var player : Node3D
@onready var inventory : Control
@onready var inventorySlots : Array[InventorySlot] = []
@onready var slotPrefab : PackedScene = preload("res://inventory_slot.tscn")

func _ready() -> void:
	player = get_parent().get_parent()
	inventory = player.get_node("InventoryUI")
	money = player.getMoney()
	print("PLAYER HAS ", money, " MANY DOLLARS")
	
	# fills the sell menu grid with the right amount of slots
	for i in ItemSlotsCount:
		var slot = slotPrefab.instantiate() as InventorySlot
		slot.InventorySlotID = i
		slot.slotPressed.connect(onItemSell)
		slot.slotDisplayPrice.connect(onDisplayPrice)
		sellMenu.add_child(slot)
		inventorySlots.append(slot)

func pressedBuyBtn():
	mainMenu.visible = false
	buyMenu.visible = true

func pressedSellBtn():
	mainMenu.visible = false
	sellMenu.visible = true
	updateSellMenu()

## INVENTORY IS A CHILD OF THE PLAYER!!!!!!

# uhhh, this will probably only be called once (unless the item disappears once bought)
func updateBuyMenu():
	pass
	# arrows
	# matches
	# knife
	# bow

# I need to update the sell menu to show the items that are in the inventory
# so, I need to get the inventory data into this script and display it here
# updated every time the player sells an item or buys an item
func updateSellMenu():
	var inventoryData = inventory.getInventoryData()
	for i in inventorySlots.size():
		if i < inventoryData.size():
			inventorySlots[i].FillSlot(inventoryData[i].SlotData)

# ON CLICK DISPLAY SELL PRICE
func onDisplayPrice(data : ItemData, slot : InventorySlot, display : bool):
	if display:
		createLabel(slot)
		print("Sell Price: ", data.sellPrice)
	else:
		deleteLabel(slot)
		print("GET OUTTA HERE")

# ON DOUBLE CLICK, SELL THE ITEM AND DISPLAY MONEY (THEN SET MONEY IN setMoney(bool))
func onItemSell(data : ItemData, slot : InventorySlot):
	print("selling bruv!")
	player.setMoney(data.sellPrice, false)
	var slotID = slot.InventorySlotID
	slot.FillSlot(null)
	deleteLabel(slot)
	inventorySlots[slot.InventorySlotID].SlotData = null
	inventory.updateInventoryData(null, slotID, 0)

func createLabel(slot : InventorySlot):
	label = Label.new()
	label.custom_minimum_size = Vector2(64.0, 64.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var settings := LabelSettings.new()
	settings.font_size = 30
	label.label_settings = settings
	label.text = "$" + str(slot.SlotData.sellPrice)
	slot.add_child(label)

func deleteLabel(slot : InventorySlot):
	label.queue_free()
