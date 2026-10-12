class_name InventoryNode
extends MeshInstance3D

@export var inventory: Inventory
@onready var interactable: Interactable

func _init():
	interactable = Interactable.new()
	interactable.interacted.connect(open)
	interactable.boot(self.mesh.create_convex_shape(), "Inventory", self)
	add_child(interactable)
	
func _ready():
	if inventory == null:
		inventory = Inventory.new()

func open(player):
	player.ui_root.toggle_external_inventory(inventory)
