@tool

class_name Grass extends MultiMeshInstance3D

const instance_count = 10000
const spread_amount := 0.5 # 0 is no spread, over 0.5 it can overlap others

var chunk_size : int
var pos : Vector3

static func create(p_pos: Vector3, p_chunk_size: int) -> Grass:
	var instance = Grass.new()
	instance.chunk_size = p_chunk_size
	instance.pos = p_pos
	
	return instance

func _ready() -> void:
	var count := 0
	var ray = RayCast3D.new()
	
	self.add_child(ray)
	ray.set_collision_mask_value(4, true)
	ray.set_collision_mask_value(1, false)
	
	self.multimesh = MultiMesh.new()
	self.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	self.multimesh.mesh = load("res://src/mesh/grass.tres")
	var mat = StandardMaterial3D.new()
	self.multimesh.mesh.surface_set_material(0, mat)
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	self.multimesh.buffer = PackedFloat32Array()
	self.multimesh.instance_count = instance_count
	
	# Take the square root of the chunk size to create a grid of
	# instances at the specified instance count
	var increment = float(chunk_size) / int(sqrt(instance_count))
	var order := range(int(sqrt(instance_count)) ** 2)
	order.shuffle()
	
	for y in int(sqrt(instance_count)) :
		for x in int(sqrt(instance_count)):
			var jitter1 = randf_range(
				((spread_amount * increment) / increment) * -1, 
				(spread_amount * increment) / increment
			)
			
			var jitter2 = randf_range(
				((spread_amount * increment) / increment) * -1, 
				(spread_amount * increment) / increment
			)
			
			ray.position = Vector3(
				(x * increment) + jitter1,
				0,
				(y * increment) + jitter2
			)
			ray.target_position = Vector3(0, -1000, 0)
			ray.force_raycast_update()
			var collision_point: Vector3 = ray.get_collision_point() - Vector3(pos.x, 0, pos.z)
			#var n: Vector3 = ray.get_collision_normal()
			
			#if n.dot(global_basis.y) <= 0.0:
				#this is to detect slopes later
			
			var t3d = Transform3D().translated(collision_point).rotated_local(Vector3.UP, randf_range(0, PI))
			self.multimesh.set_instance_transform(order[count], t3d)
			count = count + 1
