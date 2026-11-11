@tool

class_name Chunk extends Node3D

var pos : Vector3
var manager: EnvironmentManager

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
			Vector3(manager.CHUNK_SIZE, manager.CHUNK_SIZE, 0)
		])
		
	add_child(debug_shape)
