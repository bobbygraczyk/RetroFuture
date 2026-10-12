class_name InventorySlot
extends PanelContainer

const scene = preload("res://scenes/ui/inv_slot.tscn")

var inventory_grid: InventoryGrid
var index: int
var dragging: bool = false

signal drop(index: int, inventory_grid: InventoryGrid)

static func create(p_inventory: InventoryGrid, p_index: int) -> InventorySlot:
	var slot: InventorySlot = scene.instantiate()
	slot.inventory_grid = p_inventory
	slot.index = p_index
	
	return slot

func _ready():
	if inventory_grid.inventory.slots[index]:
		$Icon.texture = inventory_grid.inventory.slots[index].item.icon
	refresh()

func _get_drag_data(_at_position: Vector2) -> Variant:
	if !inventory_grid.inventory.slots[index]:
		return null
	dragging = true
	var preview = InventorySlot.create(inventory_grid, index)
	set_drag_preview(preview)
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data != self:
		inventory_grid.move(data.inventory_grid, data.index, inventory_grid, index)

func _notification(type: int) -> void:
	if type == NOTIFICATION_DRAG_END and dragging:
		dragging = false
		if not is_drag_successful():
			drop.emit(index, inventory_grid)

func refresh():
	%Amount.text = str(inventory_grid.inventory.slots[index].count) if inventory_grid.inventory.slots[index] else ""
	$Icon.texture = inventory_grid.inventory.slots[index].item.icon if inventory_grid.inventory.slots[index] else null
