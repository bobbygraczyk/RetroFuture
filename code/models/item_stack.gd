@tool

class_name ItemStack
extends Resource

@export var item: ItemData
@export var count = 1

func _init(p_item: ItemData = null, p_count := 1):
    item = p_item
    count = p_count