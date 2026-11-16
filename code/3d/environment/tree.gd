@tool

class_name TreeNode extends Node3D

@onready var trunk : Path3D = $Path3D
var nodes : Array # multidimensional array of paths

var node_count := 4
var branch_count := 2

func _ready() -> void:
	# @tool runs this on every editor load, so start from a clean curve
	trunk.curve.clear_points()
	trunk.curve.add_point(Vector3.ZERO)

	for n in node_count:
		var node : Array[Path3D]
		
		trunk.curve.add_point(Vector3(0, n + 1, 0))
		for i in branch_count:
			var path = Path3D.new()
			path.curve = Curve3D.new()
			node.push_back(path)
			
		nodes.push_front(node)
	
	build_mesh()
	

func build_mesh():
	var rad_res := 6
	var node_res := 4
	var r := 1.0

	var st := SurfaceTool.new()
	var mesh := ArrayMesh.new()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for point in trunk.curve.point_count - 1:
		var center := trunk.curve.get_point_position(point)
		var next_center := trunk.curve.get_point_position(point + 1)

		var rows := node_res - 2
		for row in rows:
			# ring height
			var low := center.lerp(next_center, float(row) / rows)
			var high := center.lerp(next_center, float(row + 1) / rows)

			for v in rad_res:
				var next_v := (v + 1) % rad_res # modulo to wrap
				var angle := TAU * v / rad_res
				var next_angle := TAU * next_v / rad_res

				var offset := Vector3(cos(angle), 0, sin(angle)) * r
				var next_offset := Vector3(cos(next_angle), 0, sin(next_angle)) * r

				var corners : Array[Vector3] = [
					low + offset,
					high + offset,
					low + next_offset,
					high + next_offset,
				]

				# wind clockwise
				st.add_vertex(corners[0])
				st.add_vertex(corners[2])
				st.add_vertex(corners[1])
				st.add_vertex(corners[2])
				st.add_vertex(corners[3])
				st.add_vertex(corners[1])

	st.generate_normals()
	st.index()
	st.commit(mesh)
	$MeshInstance3D.mesh = mesh	
