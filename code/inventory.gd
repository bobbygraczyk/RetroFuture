class_name Inventory
extends Resource

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

func has(item: ItemData, count: int) -> bool:
    var inv_count = 0

    for slot in slots:
        if slot != null && slot.item == item:
            inv_count += slot.count
    
    return inv_count >= count