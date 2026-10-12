@tool

class_name Item
extends RigidBody3D

const item_scene = preload("res://scenes/3d/item.tscn")

@export var item_stack: ItemStack
@export var is_interactable := false

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

static func create(p_item: ItemStack, p_is_interactable: bool = false) -> Item:
	var scene: Item = item_scene.instantiate()
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
		var child = Interactable.new()
		child.interacted.connect(pick_up)
		child.boot(mesh_shape, str(item_stack.item.name, " x", item_stack.count), self)
		child.scale = item_scale
		add_child(child)
	
func pick_up(player: Player):
	var remainder = player.inventory.add(item_stack.item, item_stack.count, -1)
	if remainder == 0:
		queue_free()
		player.ui_root.on_focus_changed()
	else:
		item_stack.count = remainder
