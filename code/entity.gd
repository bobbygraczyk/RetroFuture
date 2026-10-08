@tool

class_name Entity
extends Node3D

## A thing that exists in the world.
## Pass it some item data and whether
## or not you'd like it to simulate
## physics.

@export var item: ItemData
@export var physics: bool = false

var mesh_shape: Shape3D
var inited := false

# TODO: Create a MultiMesh for each reource type
# OR at least make and cache collision instead of
# generating every time

func _ready():
	if !inited:
		boot()

static func create(p_item: ItemData, p_physics: bool, is_interactable: bool) -> Entity:
	var scene: Entity = Entity.new()
	scene.item = p_item
	scene.physics = p_physics
	
	if is_interactable:
		var child = Interactable.new()
		scene.add_child(child)
	
	scene.boot()
	return scene

func boot():
	if item == null:
		queue_free()
	
	# ***
	# Build the 3D object: mesh, collision
	# ***
	mesh_shape = item.mesh.create_convex_shape()
	var collision_shape = CollisionShape3D.new()
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = item.mesh
	collision_shape.shape = mesh_shape
		
	var parent
	if physics:
		parent = RigidBody3D.new()	
	else:
		parent = StaticBody3D.new()
	
	parent.add_child(collision_shape)
	parent.add_child(mesh_instance)
	
	add_child(parent)
	
	# ***
	# Boot children
	# ***
	for child in get_children():
		if child is Interactable:
			child.boot(mesh_shape, item.name)
			
	inited = true
