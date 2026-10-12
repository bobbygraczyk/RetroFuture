class_name Inventory
extends Resource

signal drop_item(index: int, inventory: Inventory)

@export var slots: Array[ItemStack] = []

func _init(num_slots: int = 0, p_items: Array[ItemStack] = []):
	for item in p_items:
		slots.push_back(item)

	slots.resize(num_slots)

func add(item: ItemData, amount: int, slot := -1) -> int:
	if slot == -1:
		for n in slots.size():
			if amount == 0: break
			amount = place_in_slot(item, n, amount)
	else:
		amount = place_in_slot(item, slot, amount)
	
	emit_changed()
	return amount

func place_in_slot(item: ItemData, slot: int, amount: int) -> int:
	if slots[slot] == null:
		slots[slot] = ItemStack.new(item, 0)

	if slots[slot] != null && (slots[slot].item == item):
		slots[slot].count += amount
		if slots[slot].count > item.max_stack:
			var remainder = slots[slot].count - item.max_stack
			slots[slot].count = item.max_stack
			return remainder
		return 0
	
	else:
		return amount

func remove(slot: int, count: int):
	slots[slot].count -= count
	if slots[slot].count <= 0:
		slots[slot] = null
		
	emit_changed()

func has(item: ItemData, count: int) -> bool:
	var inv_count = 0

	for slot in slots:
		if slot != null && slot.item == item:
			inv_count += slot.count
	
	return inv_count >= count

func move(from_inv: Inventory, from: int, to_inv: Inventory, to: int):
	var a: ItemStack = from_inv.slots[from]
	var b: ItemStack = to_inv.slots[to]
	if b and a.item == b.item:
		var moved = min(a.count, a.item.max_stack - b.count)
		b.count += moved
		a.count -= moved
		if a.count == 0:
			from_inv.slots[from] = null
	else:
		from_inv.slots[from] = b
		to_inv.slots[to] = a
	from_inv.changed.emit()
	to_inv.changed.emit()

func drop(index: int, inventory: Inventory):
	drop_item.emit(index, inventory)
