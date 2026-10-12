class_name InventoryGrid
extends PanelContainer

const scene = preload("res://scenes/ui/inventory_grid.tscn")
const ui_slot = preload("res://scenes/ui/inv_slot.tscn")

var inventory: Inventory

signal drop_item(index: int, inventory: Inventory)

static func create(p_inventory: Inventory) -> InventoryGrid:
	var new = scene.instantiate()
	new.inventory = p_inventory
	
	return new

func _ready():
	refresh()

func refresh():
	for child in $HFlowContainer.get_children():
		child.queue_free()
	for i in inventory.slots.size():
		var slot = InventorySlot.create(inventory.slots[i], i)
		slot.swap.connect(swap_and_merge)
		slot.drop.connect(drop)
		$HFlowContainer.add_child(slot)


func swap_and_merge(from: int, to: int):
	var a: ItemStack = inventory.slots[from]
	var b: ItemStack = inventory.slots[to]

	if b and a.item == b.item:
		var moved = min(a.count, a.item.max_stack - b.count)
		b.count += moved
		a.count -= moved
		if a.count == 0:
			inventory.slots[from] = null
	else:
		inventory.slots[from] = b
		inventory.slots[to] = a

	refresh()

func drop(index: int, p_inventory: Inventory):
	drop_item.emit(index, p_inventory)
