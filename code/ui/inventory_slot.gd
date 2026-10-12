class_name InventorySlot
extends PanelContainer

const scene = preload("res://scenes/ui/inv_slot.tscn")

var stack: ItemStack
var index: int
var dragging: bool = false

signal swap(from: int, to: int)
signal drop(index: int)

static func create(p_stack: ItemStack, p_index: int) -> InventorySlot:
	var slot: InventorySlot = scene.instantiate()
	slot.stack = p_stack
	slot.index = p_index
	
	return slot

func _ready():
	if stack:
		$Icon.texture = stack.item.icon
	refresh()

func _get_drag_data(_at_position: Vector2) -> Variant:
	if stack == null:
		return null
	dragging = true
	var preview = InventorySlot.create(stack, 0)
	set_drag_preview(preview)
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventorySlot
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data != self:
		swap.emit(data.index, index)

func _notification(type: int) -> void:
	if type == NOTIFICATION_DRAG_END and dragging:
		dragging = false
		if not is_drag_successful():
			drop.emit(index, get_parent().get_parent().inventory)

func refresh():
	%Amount.text = str(stack.count) if stack else ""
