class_name Movement
extends Node

@export_group("Movement")
@export var MOVE_SPEED = 10
@export var JUMP_VELOCITY = 15

@export_group("Input sensitivity")
@export var MOUSE_SENSITIVITY = 100
@export var PAD_SENSITIVITY = 100
@export var ROTATE_SPEED = 10
@export var GRAVITY_SCALE = 0.5

@export_group("Animation")
@export var ANIM_LERP = 0.2

#Player node references
var spring_arm: SpringArm3D
var animation_tree: AnimationTree
var look_ray: RayCast3D
var look_pos_object: Node3D

var jump_lerp := 0.0
var mouse_look_delta := Vector2(0, 0)
var pad_look_delta := Vector2(0, 0)
var look_delta := Vector2(0, 0)

var player: Player

func _input(event):
	if event is InputEventMouseMotion:
		mouse_look_delta = event.relative

func _ready():
	player = get_parent()
		
	spring_arm = player.get_node('SpringArm3D')
	animation_tree = player.get_node('UAL1/AnimationTree')
	look_ray = player.get_node('SpringArm3D/RayCast3D')
	look_pos_object = player.get_node('LookPos')

func _physics_process(delta: float):
	var liVector := Input.get_vector("locomotion_left", "locomotion_right", "locomotion_up", "locomotion_down")
	look_delta = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") * PAD_SENSITIVITY
	look_delta += (mouse_look_delta * MOUSE_SENSITIVITY) / 50 #scale relative to pad
		
	spring_arm.rotate_y(-look_delta.x * 0.001)
	spring_arm.rotate_x(-look_delta.y * 0.001 * 
		(1 if (rad_to_deg(spring_arm.rotation.y) < 90 && rad_to_deg(spring_arm.rotation.y) > -90)
		else -1)
	)
	
	spring_arm.rotation.z = 0
	
	if !Input.is_action_pressed("sprint"):
		liVector = liVector * 0.5
	
	if player.is_on_floor():
		player.velocity = (
			spring_arm.get_global_transform().basis.z * liVector.y * MOVE_SPEED
		) + (
			spring_arm.get_global_transform().basis.x * liVector.x * MOVE_SPEED
		)
		player.velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			jump_lerp = JUMP_VELOCITY
			animation_tree.set("parameters/locomotion/conditions/is_jumping", true)
		else:
			jump_lerp = 0
			animation_tree.set("parameters/locomotion/conditions/is_on_floor", true)
			animation_tree.set("parameters/locomotion/conditions/is_jumping", false)
	else:
		animation_tree.set("parameters/locomotion/conditions/is_on_floor", false)
		jump_lerp = jump_lerp - (GRAVITY_SCALE + delta)
	
	var isMoving = player.velocity != Vector3.ZERO
		
	if (isMoving):
		if spring_arm.rotation.y != 0:
			player.rotate_y(spring_arm.rotation.y * (ROTATE_SPEED * delta))
			spring_arm.rotate_y(-spring_arm.rotation.y * (ROTATE_SPEED * delta))
			
	player.velocity.y = jump_lerp
	
	var lookPos: Vector3 = look_ray.global_position - (look_ray.global_transform.basis.z * 100)
	look_pos_object.global_position = lookPos
	
	var animLerp = lerp(animation_tree["parameters/locomotion/IdleWalkRun/blend_position"], liVector * Vector2(1, -1), ANIM_LERP)
	animation_tree.set("parameters/locomotion/IdleWalkRun/blend_position", animLerp)

	player.move_and_slide()
