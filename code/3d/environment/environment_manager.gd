@tool

class_name EnvironmentManager extends Node

const WORLD_SIZE := 128
const CHUNK_SIZE := 16

var chunks : Array[Chunk]

## Define a chunk
## Create and store references
## Spawn grass
## Calculate player view
## Don't render out of sight chunks
## Reduce visible mesh instances in faraway chunks

func _ready() -> void:
	@warning_ignore("integer_division")
	const res = int(WORLD_SIZE / CHUNK_SIZE)
	chunks.resize(res * res)
	
	for y in res:
		for x in res:
			var chunk = Chunk.create(Vector3((x * CHUNK_SIZE), 0, (y * CHUNK_SIZE)), self)
			chunks[x + (y * res)] = chunk
			add_child(chunk)
