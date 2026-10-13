class_name InventoryGrid
extends PanelContainer

const scene = preload("res://scenes/ui/inventory_grid.tscn")

var selection := -1

@export var inventory: Inventory
@export var ui_slots: Array[InventorySlot]

static func create(p_inventory: Inventory) -> InventoryGrid:
	var new = scene.instantiate() as InventoryGrid
	new.inventory = p_inventory
	
	return new

func _ready():
	inventory.changed.connect(refresh)
	refresh()

func refresh():
	ui_slots = []
	for child in $HFlowContainer.get_children():
		child.queue_free()
	for i in inventory.slots.size():
		var slot = InventorySlot.create(inventory, i)
		$HFlowContainer.add_child(slot)
		ui_slots.push_back(slot)
		if i == selection:
			slot.highlight_on()
