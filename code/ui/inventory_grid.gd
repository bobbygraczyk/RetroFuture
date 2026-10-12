class_name InventoryGrid
extends PanelContainer

const scene = preload("res://scenes/ui/inventory_grid.tscn")
const ui_slot = preload("res://scenes/ui/inv_slot.tscn")

var inventory: Inventory

signal drop_item(index: int, inventory_grid: InventoryGrid)

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
		var slot = InventorySlot.create(self, i)
		slot.drop.connect(drop)
		$HFlowContainer.add_child(slot)


static func move(from_inv: InventoryGrid, from: int, to_inv: InventoryGrid, to: int):
	var a: ItemStack = from_inv.inventory.slots[from]
	var b: ItemStack = to_inv.inventory.slots[to]
	if b and a.item == b.item:
		var moved = min(a.count, a.item.max_stack - b.count)
		b.count += moved
		a.count -= moved
		if a.count == 0:
			from_inv.inventory.slots[from] = null
	else:
		from_inv.inventory.slots[from] = b
		to_inv.inventory.slots[to] = a
	
	from_inv.refresh()
	to_inv.refresh()

func drop(index: int, inventory_grid: InventoryGrid):
	drop_item.emit(index, inventory_grid)
