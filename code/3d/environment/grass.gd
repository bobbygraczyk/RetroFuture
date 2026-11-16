@tool

class_name Grass extends MultiMeshInstance3D

const instance_count = 10000
const spread_amount := 0.5 # 0 is no spread, over 0.5 it can overlap others

var splat : Image
var chunk_size : int
var pos : Vector3

static func create(p_pos: Vector3, p_chunk_size: int, p_splat: Image) -> Grass:
	var instance = Grass.new()
	instance.chunk_size = p_chunk_size
	instance.pos = p_pos
	instance.splat = p_splat
	
	return instance

func _ready() -> void:
	var ray = RayCast3D.new()
	
	self.add_child(ray)
	ray.set_collision_mask_value(4, true)
	ray.set_collision_mask_value(1, false)
	
	self.multimesh = MultiMesh.new()
	self.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	self.multimesh.mesh = load("res://src/mesh/grass.tres")

	# Take the square root of the chunk size to create a grid of
	# instances at the specified instance count
	var increment = float(chunk_size) / int(sqrt(instance_count))
	var transforms: Array[Transform3D] = []

	for y in int(sqrt(instance_count)):
		for x in int(sqrt(instance_count)):
			var grass_pos := Vector2(x, y)
			var splat_pos := (grass_pos / sqrt(instance_count)) * splat.get_size().x
			
			var color = splat.get_pixel(splat_pos.x, splat_pos.y)
			if Color(color, 1.0) == Color.BLUE:
				# 1 for alpha 1
				# 10 for alpha 0
				# only do every n times
				# to thin grass based off alpha
				if color.a > 0.1 and (x + randi_range(0, 10)) % int(color.a + (10 - (color.a * 10))) == 0:
					var jitter1 = randf_range(
						(spread_amount * increment) * -1, 
						(spread_amount * increment)
					)
					
					var jitter2 = randf_range(
						(spread_amount * increment) * -1, 
						(spread_amount * increment)
					)
					
					ray.position = Vector3(
						(x * increment) + jitter1,
						0,
						(y * increment) + jitter2
					)
					ray.target_position = Vector3(0, -1000, 0)
					ray.force_raycast_update()
					var collision_point: Vector3 = ray.get_collision_point() - Vector3(pos.x, 0, pos.z)
					var n: Vector3 = ray.get_collision_normal()
					
					if n.dot(global_basis.y) <= 0.9:
						#this is to detect slopes
						continue

					transforms.append(Transform3D().translated(collision_point).rotated_local(Vector3.UP, randf_range(0, PI)))

	transforms.shuffle()
	self.multimesh.instance_count = transforms.size()
	for i in transforms.size():
		self.multimesh.set_instance_transform(i, transforms[i])
