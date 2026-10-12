class_name Player
extends CharacterBody3D

var focus_target: Interactable = null

@onready var inventory = Inventory.new(20, [])
@onready var ui_root: UIRoot = $"../UIRoot"
@onready var look_ray: RayCast3D = $SpringArm3D/RayCast3D

signal focus_changed(target: Interactable)

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$SpringArm3D/RayCast3D.add_exception(self)

func _physics_process(_delta: float):
	var hit = look_ray.get_collider() if look_ray.is_colliding() else null
	var new_target: Interactable = hit if hit is Interactable else null
	
	if new_target != focus_target:
		if is_instance_valid(focus_target):
			focus_target.end_hover()
		focus_target = new_target
		if focus_target:
			focus_target.hover()
		focus_changed.emit(focus_target)
		
	if Input.is_action_just_pressed("interact"):
		if ui_root.external_inventory_ref:
			ui_root.close_external_inventory()
		elif focus_target:
			focus_target.interact(self)
		
func drop_item(index: int, p_inventory: Inventory):
	var drop_stack = p_inventory.slots[index]
	p_inventory.slots[index] = null
	p_inventory.emit_changed()
	
	var drop_entity = Item.create(drop_stack, true)
	
	get_parent().add_child(drop_entity)
	drop_entity.global_position = self.global_position + -global_basis.z + Vector3(0, 2, -1)
