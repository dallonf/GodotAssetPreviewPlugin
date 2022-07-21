tool
extends Spatial

export var radius := 5

onready var camera: Camera = $Camera

var camera_orbit: Vector2 = Vector2.ZERO
	
func drag(amount: Vector2):
	camera_orbit += amount
	update_camera()

func update_camera():
	var camera_position_horizontal = Vector3.FORWARD.rotated(Vector3.UP, camera_orbit.x)
	var camera_vertical_rot_axis = camera_position_horizontal.cross(Vector3.UP)
	var camera_position = camera_position_horizontal.rotated(camera_vertical_rot_axis, camera_orbit.y) * radius
	
	camera.look_at_from_position(camera_position, Vector3.ZERO, Vector3.UP)
