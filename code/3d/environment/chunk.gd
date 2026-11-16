@tool

class_name Chunk extends Node3D

@onready var mesh := MeshInstance3D.new()
@onready var static_body := StaticBody3D.new()

var pos : Vector3
var manager: EnvironmentManager
var lod := 0
var grass: Grass
var splat_texture: ImageTexture
var splat: Image
var index: int

static func create(p_index: int, p_position: Vector3, p_manager: EnvironmentManager) -> Chunk:
	var instance := Chunk.new()
	instance.index = p_index
	instance.pos = p_position
	instance.manager = p_manager
	instance.splat = Image.create(128, 128, false, Image.FORMAT_RGBA8)
	instance.splat_texture = ImageTexture.create_from_image(instance.splat)
	
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
	
	# load saved splat map if it exists
	if FileAccess.file_exists(str('res://bin/chunk_data/', index, '.tres')):
		splat = await load(str('res://bin/chunk_data/', index, '.tres'))
	
	splat_texture.update(splat)
	add_child(static_body)
	add_child(mesh)
	
	create_ground_mesh()
	reload_grass()

func change_lod(level: int) -> void:
	lod = level
	if grass:
		grass.multimesh.visible_instance_count = int(grass.multimesh.instance_count / (level + 1))

func reload_grass():
	if grass:
		grass.queue_free()
	grass = Grass.create(position, manager.CHUNK_SIZE, splat)
	add_child(grass)

func create_ground_mesh():
	const res = 12
	var st = SurfaceTool.new()
	var ray = RayCast3D.new()
	ray.set_collision_mask_value(1, false)
	ray.set_collision_mask_value(8, true)
	add_child(ray)
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var array_mesh := ArrayMesh.new()
	var verts : Array[Vector3] = []
	verts.resize(pow(res + 1, 2))
	for y: float in res + 1: # go to index 13 to wrap
		for x: float in res + 1:
			ray.position = Vector3((x / res) * manager.CHUNK_SIZE, 100,  (y / res) * manager.CHUNK_SIZE)
			ray.target_position = Vector3(0, -1000, 0)
			ray.force_raycast_update()
			verts[x + (y * (res + 1))] = ray.get_collision_point() - position
	
	for row in res:
		var row_i := row * (res + 1)
		var next_i := (row + 1) * (res + 1)
		for quad in res:
			st.add_vertex(verts[row_i + quad])     #0, 0
			st.add_vertex(verts[row_i + 1 + quad]) #0, 1
			st.add_vertex(verts[next_i + quad])    #1, 0
			
			st.add_vertex(verts[next_i + quad])    #1, 0
			st.add_vertex(verts[row_i + 1 + quad]) #0, 1
			st.add_vertex(verts[next_i + 1 + quad])#1, 1
	
	st.generate_normals()
	st.index()
	st.commit(array_mesh)
	
	var ground_material = ShaderMaterial.new()
	ground_material.shader = preload("res://code/shaders/ground.gdshader")
	ground_material.set_shader_parameter("grass_color", Color.SEA_GREEN)
	ground_material.set_shader_parameter("dirt_color", Color.SADDLE_BROWN)
	ground_material.set_shader_parameter("rock_color", Color.DIM_GRAY)
	ground_material.set_shader_parameter("splat", splat_texture)
	ground_material.set_shader_parameter("size", Vector3(manager.CHUNK_SIZE, manager.CHUNK_SIZE, manager.CHUNK_SIZE))
	ground_material.set_shader_parameter("start", position)
	ground_material.set_shader_parameter("grass_index_color", Color.BLUE)
	mesh.material_override = ground_material
	mesh.mesh = array_mesh
	var collider := CollisionShape3D.new()
	collider.shape = array_mesh.create_trimesh_shape()
	static_body.set_collision_layer_value(1, true)
	static_body.set_collision_layer_value(4, true)
	static_body.add_child(collider)
	
	
