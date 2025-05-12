extends Control
class_name InventorySlot

@export var IconSlot : TextureRect

var InventorySlotID : int = -1
var SlotFilled : bool = false

var SlotData : ItemData

var click_timer := 0
var click_threshold := 0.25
var awaiting_second_click := false

signal OnItemDropped(fromSlotID, toSlotID)
signal slotPressed(data : ItemData, slot : InventorySlot)
signal slotDisplayPrice(data : ItemData, slot : InventorySlot, display : bool)

func FillSlot(data : ItemData):
	SlotData = data
	if SlotData != null:
		SlotFilled = true
		IconSlot.texture = data.Icon
	else:
		SlotFilled = false
		IconSlot.texture = null

## shop stuff
func onPressed():
	if SlotData != null:
		slotPressed.emit(SlotData, self)

func onHover():
	if SlotData != null:
		slotDisplayPrice.emit(SlotData, self, true)

func offHover():
	if SlotData != null:
		slotDisplayPrice.emit(SlotData, self, false)

func _get_drag_data(at_position: Vector2) -> Variant:
	if SlotFilled:
		var preview : TextureRect = TextureRect.new()
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.size = IconSlot.size
		preview.pivot_offset = IconSlot.size / 2.0
		preview.rotation = 2.0
		preview.texture = IconSlot.texture
		set_drag_preview(preview)
		
		return {"Type": "Item", "ID": InventorySlotID}
	else:
		return false

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data["Type"] == "Item"

func _drop_data(at_position: Vector2, data: Variant) -> void:
	OnItemDropped.emit(data["ID"], InventorySlotID)
