class_name UIRoot
extends Control

@export var player_ref: Player

var inventory_ui_ref: InventoryGrid
var external_inventory_ref: InventoryGrid

func _ready():
	player_ref.focus_changed.connect(on_focus_changed)

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
	grid.drop_item.connect(player_ref.drop_item)
	add_child(grid)
	return grid
		
func refresh():
	if inventory_ui_ref:
		inventory_ui_ref.refresh()
	if external_inventory_ref:
		external_inventory_ref.refresh()
