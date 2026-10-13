# NO CLASSNAME BECAUSE IT'S
# AN AUTOLOAD

extends Node

# player.gd 
signal item_equipped(item: ItemData)
signal item_unequipped(item: ItemData)

signal item_picked_up(stack: ItemStack)
signal item_dropped(stack: ItemStack)
signal item_moved(stack: ItemStack, from: Inventory, to: Inventory)

# not implemented
signal item_used(item: ItemData)
