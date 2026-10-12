@tool

class_name Interactable
extends Area3D

var display_text: String
var parent: Variant

signal interacted(player: Player)

func boot(shape: Shape3D, p_text: String, p_parent: Variant):
	var col_shape := CollisionShape3D.new()
	col_shape.shape = shape
	add_child(col_shape)
	
	display_text = p_text
	parent = p_parent
	
func hover():
	if parent is Item:
		parent.mesh_instance.set_instance_shader_parameter("size", 1.05)
	if parent is InventoryNode:
		parent.set_instance_shader_parameter("size", 1.05)

func end_hover():
	if parent is Item:
		parent.mesh_instance.set_instance_shader_parameter("size", 0)
	if parent is InventoryNode:
		parent.set_instance_shader_parameter("size", 0)

func interact(player: Player):
	interacted.emit(player)
