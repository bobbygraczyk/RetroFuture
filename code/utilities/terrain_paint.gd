@tool
class_name TerrainPaint extends MarginContainer

@onready var manager: EnvironmentManager = $"../EnvironmentManager"
@onready var ray := RayCast3D.new()
@onready var sphere := CSGSphere3D.new()
@export var on := false
@export var add_or_subtract := true
@export_range(0.01, 1) var falloff : float = 1.0
@export_range(0, 20) var brush_size : float = 1.0

func _ready() -> void:
	if !Engine.is_editor_hint():
		queue_free()
		return
	ray.set_collision_mask_value(4, true)
	add_child(ray)
	get_parent().add_child.call_deferred(sphere)
	
	sphere.material = preload("res://src/materials/semi_transparent.tres")
	sphere.radius = 1
	
func _process(delta: float) -> void:
	if ray and sphere:
		if sphere.visible != on:
			sphere.visible = !sphere.visible
		if on:
			var viewport := EditorInterface.get_editor_viewport_3d(0)
			var mouse_coords := viewport.get_mouse_position()
			var camera := viewport.get_camera_3d()

			ray.position = camera.project_ray_origin(mouse_coords)
			ray.target_position = camera.project_ray_normal(mouse_coords) * 1000
			ray.force_raycast_update()
				
			sphere.radius = brush_size
			sphere.position = ray.get_collision_point()
			
	if on and Input.is_key_pressed(KEY_P):
		splat_paint(sphere.position, brush_size)
		
func get_chunk_grid_coords(location: Vector3) -> Vector2:
	return Vector2i(
		floori(location.x + (manager.WORLD_SIZE / 2)) / manager.CHUNK_SIZE,
		floori(location.z + (manager.WORLD_SIZE / 2)) / manager.CHUNK_SIZE
	)

func get_chunk_index_from_coords(coords: Vector2) -> int:
	return coords.x + (coords.y * (manager.WORLD_SIZE / manager.CHUNK_SIZE))

func splat_paint(location: Vector3, radius: float):
	var chunks : Array[Chunk] = []
	
	var world_xy := Vector2(location.x, location.z)
	var rv := Vector2(radius, radius)
	var world_bb := Rect2(world_xy - rv, rv * 2)
	
	## get the range of indices for both x and y
	## from the corners
	var start = get_chunk_grid_coords(Vector3(world_bb.position.x, 0, world_bb.position.y))
	var end = get_chunk_grid_coords(Vector3(world_bb.end.x, 0, world_bb.end.y))
	
	for dy in range(start.y, end.y + 1):
		for dx in range(start.x, end.x + 1):
			var index = get_chunk_index_from_coords(Vector2(dx, dy))
			if index < manager.chunks.size():
				chunks.push_back(manager.chunks[index])


	for chunk in chunks:
		var image_size := Vector2(chunk.splat.get_size())

		# the mouse location in world space projected to the image space
		var local_pos := Vector2(
			location.x - chunk.position.x,
			location.z - chunk.position.z
		)

		var image_pos := (local_pos / manager.CHUNK_SIZE) * image_size
		
		# the radius of the circle in world space scaled to image space
		var scaled_radius := (radius / manager.CHUNK_SIZE) * image_size.x

		# a bounding box around the whole circle (center + radius),
		# clipped to the image so set_pixel stays in range
		var r := ceili(scaled_radius)
		var bb := Rect2i(
			Vector2i(image_pos.floor()) - Vector2i(r, r),
			Vector2i(r, r) * 2 + Vector2i.ONE
		).intersection(Rect2i(Vector2i.ZERO, chunk.splat.get_size()))

		for y in range(bb.position.y, bb.end.y):
			for x in range(bb.position.x, bb.end.x):
				# measure radius from the pixel's center
				var distance := (Vector2(x, y) + Vector2(0.5, 0.5)).distance_squared_to(image_pos)
				if (distance <= (scaled_radius * scaled_radius)):
					var color := Color.BLUE
					if add_or_subtract:
						var alpha : float = smoothstep(1.0, 1.0 - falloff, sqrt(distance) / scaled_radius)
						color.a = maxf(chunk.splat.get_pixel(x, y).a, alpha)
					
					else:
						var alpha : float = smoothstep(0, 1.0 - falloff, sqrt(distance) / scaled_radius)
						color.a = minf(chunk.splat.get_pixel(x, y).a, alpha)
					chunk.splat.set_pixel(x, y, color)
		
		var chunk_index := get_chunk_index_from_coords(get_chunk_grid_coords(chunk.position))
		ResourceSaver.save(chunk.splat, str('res://bin/chunk_data/', chunk_index, '.tres'))
		chunk.splat_texture.update(chunk.splat)
		chunk.reload_grass()
