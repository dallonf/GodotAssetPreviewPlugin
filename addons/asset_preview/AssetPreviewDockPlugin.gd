tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("AssetPreviewDock.tscn").instance()
	dock.init(get_editor_interface())
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)


func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
