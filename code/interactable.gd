@tool

class_name Interactable
extends Area3D

var display_text: String

func boot(shape: Shape3D, p_text: String):
	var col_shape := CollisionShape3D.new()
	col_shape.shape = shape
	add_child(col_shape)
	
	display_text = p_text

func is_interactable() -> bool:
	return true
