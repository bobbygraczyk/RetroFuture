@tool

class_name Interactable
extends Area3D

var display_text: String
var parent: Variant
var shape: Shape3D
var highlight_mesh: MeshInstance3D

signal interacted(player: Player)

static func create(p_shape: Shape3D, p_text: String, p_parent: Variant, p_highlight_mesh: MeshInstance3D = null) -> Interactable:
	var instance = Interactable.new()
	
	instance.shape = p_shape
	instance.display_text = p_text
	instance.parent = p_parent
	instance.highlight_mesh = p_highlight_mesh

	return instance
	
func _ready():
	var col_shape := CollisionShape3D.new()
	col_shape.shape = shape
	add_child(col_shape)
	
func hover():
	highlight_mesh.set_instance_shader_parameter("size", 1.05)

func end_hover():
	highlight_mesh.set_instance_shader_parameter("size", 0)

func interact(player: Player):
	interacted.emit(player)
