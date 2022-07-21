tool
extends ViewportContainer

export var PIXELS_PER_TURN := 400

const SpatialPreview = preload("SpatialPreview.gd")
onready var spatial_preview: SpatialPreview = $Viewport/SpatialPreview
onready var spatial_preview_socket: Spatial = $Viewport/SpatialPreview/SpatialPreviewSocket

enum Mode {
	NONE,
	TWO_D,
	THREE_D
}

var mode
var dragging := false

func set_instance(instance: Node) -> bool:
	if instance is Spatial:
		clear_instance()
		spatial_preview_socket.add_child(instance)
		mode = Mode.THREE_D
		return true
	
	return false
	
func clear_instance():
	for child in spatial_preview_socket.get_children():
		child.queue_free()

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		dragging = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if dragging and event is InputEventMouseMotion:
		spatial_preview.drag(event.relative / PIXELS_PER_TURN)
	if dragging and event is InputEventMouseButton and not event.pressed and event.button_index == 1:
		dragging = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
