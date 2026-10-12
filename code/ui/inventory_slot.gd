class_name InventorySlot
extends PanelContainer

const scene = preload("res://scenes/ui/inv_slot.tscn")

var inventory: Inventory
var index: int
var dragging: bool = false

static func create(p_inventory: Inventory, p_index: int) -> InventorySlot:
	var slot = scene.instantiate() as InventorySlot
	slot.inventory = p_inventory
	slot.index = p_index
	
	return slot

func _ready():
	if inventory.slots[index]:
		$Icon.texture = inventory.slots[index].item.icon
	refresh()

func _get_drag_data(_at_position: Vector2) -> Variant:
	if inventory.slots[index] == null:
		return null
	dragging = true
	var preview = InventorySlot.create(inventory, index)
	set_drag_preview(preview)
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data != self:
		inventory.move(data.inventory, data.index, inventory, index)

func _notification(type: int) -> void:
	if type == NOTIFICATION_DRAG_END and dragging:
		dragging = false
		if not is_drag_successful():
			inventory.drop(index, inventory)

func refresh():
	%Amount.text = str(inventory.slots[index].count) if inventory.slots[index] else ""
	$Icon.texture = inventory.slots[index].item.icon if inventory.slots[index] else null
