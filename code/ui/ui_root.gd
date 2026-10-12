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
			inventory_ui_ref = InventoryGrid.create(player_ref.inventory)
			inventory_ui_ref.drop_item.connect(player_ref.drop_item)
			add_child(inventory_ui_ref)
	if Input.is_action_just_pressed("interact") and external_inventory_ref:
		external_inventory_ref.queue_free()
			
func toggle_external_inventory(inventory):
	if (external_inventory_ref):
			external_inventory_ref.queue_free()
	else:
		external_inventory_ref = InventoryGrid.create(inventory)
		external_inventory_ref.drop_item.connect(player_ref.drop_item)
		print(external_inventory_ref.global_position)
		add_child(external_inventory_ref)
		print(external_inventory_ref)
		
func refresh():
	if inventory_ui_ref:
		inventory_ui_ref.refresh()
	if external_inventory_ref:
		external_inventory_ref.refresh()
