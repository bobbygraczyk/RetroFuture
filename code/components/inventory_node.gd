class_name InventoryNode
extends MeshInstance3D

const outline_material = preload("res://res/base_material.tres")

@export var inventory: Inventory

func _init():
	var interactable = Interactable.create(self.mesh.create_convex_shape(), "Inventory", self, self)
	interactable.interacted.connect(open)
	add_child(interactable)
	
	self.material_override = outline_material
	
func _ready():
	if inventory == null:
		inventory = Inventory.new()

func open(player):
	player.ui_root.toggle_external_inventory(inventory)
