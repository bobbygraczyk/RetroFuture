@tool

class_name Main extends Node3D

var camera: Camera3D

func _ready() -> void:
	if Engine.is_editor_hint():
		camera = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
	else:
		camera = $Player/SpringArm3D/Camera3D

func _process(_delta) -> void:
	$EnvironmentManager.view_update(camera.get_frustum(), camera.global_position)
