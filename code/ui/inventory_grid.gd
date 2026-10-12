class_name InventoryGrid
extends PanelContainer

const scene = preload("res://scenes/ui/inventory_grid.tscn")

var inventory: Inventory

static func create(p_inventory: Inventory) -> InventoryGrid:
	var new = scene.instantiate() as InventoryGrid
	new.inventory = p_inventory
	
	return new

func _ready():
	inventory.changed.connect(refresh)
	refresh()

func refresh():
	for child in $HFlowContainer.get_children():
		child.queue_free()
	for i in inventory.slots.size():
		var slot = InventorySlot.create(inventory, i)
		$HFlowContainer.add_child(slot)
