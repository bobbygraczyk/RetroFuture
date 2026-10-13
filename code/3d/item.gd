@tool

class_name Item
extends RigidBody3D

const item_scene = preload("res://scenes/3d/item.tscn")

@export var item_stack: ItemStack
@export var is_interactable := false

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

static func create(p_item: ItemStack, p_is_interactable: bool = false) -> Item:
	var scene = item_scene.instantiate() as Item
	scene.item_stack = p_item
	scene.is_interactable = p_is_interactable

	return scene

func _ready() -> void:
	var item_scale = Vector3(item_stack.item.scale, item_stack.item.scale, item_stack.item.scale)
	var mesh_shape = item_stack.item.mesh.create_convex_shape()
	$CollisionShape3D.shape = mesh_shape
	$CollisionShape3D.scale = item_scale
	mesh_instance.mesh = item_stack.item.mesh
	mesh_instance.scale = item_scale
	
	if is_interactable:
		var child = Interactable.create(mesh_shape, str(item_stack.item.name, " x", item_stack.count), self, mesh_instance)
		child.interacted.connect(pick_up)
		child.scale = item_scale
		add_child(child)
	
func pick_up(player: Player):
	var remainder = player.inventory.add(item_stack.item, item_stack.count, -1)
	Events.item_picked_up.emit(item_stack)
	if remainder == 0:
		player.ui_root.on_focus_changed(null)
		queue_free()
	else:
		item_stack.count = remainder
