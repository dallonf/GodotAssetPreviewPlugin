tool
extends EditorPlugin

const PLUGIN_TO_RELOAD: String = "asset_preview"

func _enter_tree():
	pass


func _exit_tree():
	pass

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_F11:
		get_editor_interface().set_plugin_enabled(PLUGIN_TO_RELOAD, false)
		get_editor_interface().set_plugin_enabled(PLUGIN_TO_RELOAD, true)
