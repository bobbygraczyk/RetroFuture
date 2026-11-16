@tool

class_name EnvironmentManager extends Node

const WORLD_SIZE := 256
const CHUNK_SIZE := 32
const LOD_SCALE := 32

var chunks : Array[Chunk]

func _ready() -> void:
	@warning_ignore("integer_division")
	const res = int(WORLD_SIZE / CHUNK_SIZE)
	chunks.resize(res * res)
	
	for y in res:
		for x in res:
			var chunk = Chunk.create((x + (y * res)), Vector3(
				(x * CHUNK_SIZE) - int(WORLD_SIZE / 2), 
				0, 
				(y * CHUNK_SIZE) - int(WORLD_SIZE / 2)
			), self)
			chunks[x + (y * res)] = chunk
			add_child(chunk)

func view_update(frustrum: Array[Plane], player_pos: Vector3) -> void:
	for chunk in chunks:
		var center: Vector3 = chunk.global_position + Vector3(CHUNK_SIZE / 2.0, 0, CHUNK_SIZE / 2.0)
		var lod := int(
			Vector3(center.x, 0, center.z).distance_to(Vector3(player_pos.x, 0, player_pos.z)) 
			/ LOD_SCALE)
		
		if chunk.lod != lod:
			chunk.change_lod(lod)

func is_chunk_in_view(box: AABB, frustrum: Array[Plane]) -> bool:
	for plane in frustrum:
		var n_vertex := Vector3(
			box.position.x if plane.normal.x >= 0.0 else box.end.x,
			box.position.y if plane.normal.y >= 0.0 else box.end.y,
			box.position.z if plane.normal.z >= 0.0 else box.end.z
		)
		if plane.is_point_over(n_vertex):
			return false
			
	return true
