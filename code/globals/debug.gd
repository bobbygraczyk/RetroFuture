@tool

class_name DebugDraw extends MeshInstance3D

var immediate_mesh = ImmediateMesh.new()
var material = ORMMaterial3D.new()
var verts: Array[Vector3]
var color: Color

static func create(p_verts: Array[Vector3], p_color: Color = Color.PURPLE) -> DebugDraw:
	var instance = DebugDraw.new()
	
	instance.verts = p_verts
	instance.color = p_color
	
	return instance

func _ready() -> void:
	mesh = immediate_mesh
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
	
	for n in verts.size():
		immediate_mesh.surface_add_vertex(verts[n])
	
	immediate_mesh.surface_end()
