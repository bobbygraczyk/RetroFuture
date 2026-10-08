class_name Player
extends CharacterBody3D

@onready var inventory = Inventory.new(20, [])
@onready var ui_root = $"../UIRoot"

@export var focus_target: Interactable = null

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$SpringArm3D/RayCast3D.add_exception(self)

func _physics_process(_delta: float):
	focus_target = null
	ui_root.draw_interactable_name("")
	if $SpringArm3D/RayCast3D.is_colliding():
		var collision_target = $SpringArm3D/RayCast3D.get_collider()
		if collision_target is Interactable:
			focus_target = collision_target
			ui_root.draw_interactable_name(collision_target.display_text)
			
