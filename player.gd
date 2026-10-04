extends CharacterBody3D

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var animation_tree: AnimationTree = $UAL1/AnimationTree
@onready var look_ray: RayCast3D = $SpringArm3D/RayCast3D
@onready var look_pos_object: Node3D = $LookPos

@export var MOVE_SPEED = 10
@export var LOOK_SPEED = 0.01
@export var ROTATE_SPEED = 10
@export var JUMP_VELOCITY = 15
@export var GRAVITY_SCALE = 0.5
@export var ANIM_LERP = 0.2

var jump_lerp := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	_locomotion(delta)

func _input(event):
	var controllerLookVector = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if event is InputEventMouseMotion:
		_look(event.relative)
	
	if controllerLookVector != Vector2.ZERO:
		_look(controllerLookVector)
	
func _look(lookDelta):
	spring_arm.rotate_y(-lookDelta.x * LOOK_SPEED)
	spring_arm.rotate_x(-lookDelta.y * LOOK_SPEED * 
		(1 if (rad_to_deg(spring_arm.rotation.y) < 90 && rad_to_deg(spring_arm.rotation.y) > -90)
		else -1)
	)
	spring_arm.rotation.z = 0

func _locomotion(delta: float):
	var liVector := Input.get_vector("locomotion_left", "locomotion_right", "locomotion_up", "locomotion_down")
	
	if !Input.is_action_pressed("sprint"):
		liVector = liVector * 0.5
	
	if is_on_floor():
		velocity = (
			spring_arm.get_global_transform().basis.z * liVector.y * MOVE_SPEED
		) + (
			spring_arm.get_global_transform().basis.x * liVector.x * MOVE_SPEED
		)
		velocity.y = 0
		
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
	
	var isMoving = velocity != Vector3.ZERO
		
	if (isMoving):
		if spring_arm.rotation.y != 0:
			rotate_y(spring_arm.rotation.y * (ROTATE_SPEED * delta))
			spring_arm.rotate_y(-spring_arm.rotation.y * (ROTATE_SPEED * delta))
			
	velocity.y = jump_lerp
	
	var lookPos: Vector3 = look_ray.global_position - (look_ray.global_transform.basis.z * 100)
	look_pos_object.global_position = lookPos
	
	var animLerp = lerp(animation_tree["parameters/locomotion/IdleWalkRun/blend_position"], liVector * Vector2(1, -1), ANIM_LERP)
	animation_tree.set("parameters/locomotion/IdleWalkRun/blend_position", animLerp)
		
	move_and_slide()
