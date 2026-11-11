@tool

class_name Chunk extends Node3D

var pos : Vector3
var manager: EnvironmentManager
var lod := 0
var grass: Grass

static func create(p_position: Vector3, p_manager: EnvironmentManager) -> Chunk:
	var instance = Chunk.new()
	instance.pos = p_position
	instance.manager = p_manager
	
	return instance

func _ready() -> void:
	self.position = pos
	
	var debug_shape = DebugDraw.create([
			Vector3.ZERO,
			Vector3(manager.CHUNK_SIZE, 0, 0),
			Vector3(manager.CHUNK_SIZE, 0, manager.CHUNK_SIZE),
			Vector3(0, 0, manager.CHUNK_SIZE),
			Vector3(0, -manager.CHUNK_SIZE, manager.CHUNK_SIZE),
			Vector3(0, -manager.CHUNK_SIZE, 0),
			Vector3(manager.CHUNK_SIZE, -manager.CHUNK_SIZE, 0),
			Vector3(manager.CHUNK_SIZE, -manager.CHUNK_SIZE, manager.CHUNK_SIZE)
		])
		
	add_child(debug_shape)
	
	grass = Grass.create(position, manager.CHUNK_SIZE)
	add_child(grass)

func change_lod(level: int) -> void:
	print(level, lod)
	lod = level
	grass.multimesh.visible_instance_count = int(grass.instance_count / (level + 1))
