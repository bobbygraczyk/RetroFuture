class_name UIRoot
extends Control

@export var player_ref: Player

@onready var toolbar: InventoryGrid = $InventoryGrid
@onready var EventLog: RichTextLabel = $ScrollContainer/RichTextLabel

var inventory_ui_ref: InventoryGrid
var external_inventory_ref: InventoryGrid

func _ready():
	toolbar.inventory.drop_item.connect(player_ref.drop_item)
	player_ref.focus_changed.connect(on_focus_changed)
	Events.item_equipped.connect(func(item): add_to_log("Equipped %s" % item.name))
	Events.item_unequipped.connect(func(item): add_to_log("Unequipped %s" % item.name))
	Events.item_used.connect(func(item): add_to_log("Used %s" % item.name))
	Events.item_picked_up.connect(func(stack): add_to_log("Picked up %s x%d" % [stack.item.name, stack.count]))
	Events.item_dropped.connect(func(item, n): add_to_log("Dropped %s x%d" % [item.name, n]))
	Events.item_moved.connect(func(stack, from, to): add_to_log("Moved %s x%d from %s to %s" % [stack.item.name, stack.count, from.name, to.name]))

func on_focus_changed(target: Interactable = null):
	if target:
		$Label.text = target.display_text
	else:
		$Label.text = ""

func _physics_process(_delta):
	if Input.is_action_just_pressed("inventory_toggle"):
		if (inventory_ui_ref):
			inventory_ui_ref.queue_free()
		else:
			inventory_ui_ref = open_grid(player_ref.inventory)
	for i in 8:
		if Input.is_action_just_pressed("toolbar_%d" % i):
			toolbar_action(i)

			
func toggle_external_inventory(inventory):
	if (external_inventory_ref):
			close_external_inventory()
	else:
		external_inventory_ref = open_grid(inventory)
		external_inventory_ref.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT, Control.PRESET_MODE_KEEP_SIZE)

func close_external_inventory():
	external_inventory_ref.queue_free()
	external_inventory_ref = null
	
func open_grid(inventory: Inventory) -> InventoryGrid:
	var grid := InventoryGrid.create(inventory)
	if not inventory.drop_item.is_connected(player_ref.drop_item):
		inventory.drop_item.connect(player_ref.drop_item)

	add_child(grid)
	return grid

func toolbar_action(idx: int):
	if toolbar.inventory.slots[idx] == null:
		return
	
	var item: ItemData = toolbar.inventory.slots[idx].item
	
	if item:
		match toolbar.inventory.slots[idx].item.type:
			ItemData.ItemType.TOOL:
				if idx == toolbar.selection:
					player_ref.unequip(item)
					toolbar.ui_slots[idx].highlight_off()
					toolbar.selection = -1
				else:
					player_ref.equip(item)
					toolbar.ui_slots[idx].highlight_on()
					toolbar.selection = idx
			_:
				pass

func add_to_log(text: String):
	print(text)
	EventLog.text = EventLog.text + "\n" + text
