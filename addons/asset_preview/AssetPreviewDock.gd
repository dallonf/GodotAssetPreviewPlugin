tool
extends Control

export(bool) var docked = false

var editor_interface: EditorInterface
var selected_path setget set_selected_path
var files := []

onready var folder_path_input: LineEdit = $Top/FolderPath
onready var file_list: ItemList = $VSplitContainer/FileList
onready var debug_label: Label = $VSplitContainer/DebugLabel
const PreviewViewportContainer = preload("PreviewViewportContainer.gd")
onready var viewport_container: PreviewViewportContainer = $VSplitContainer/ViewportContainer

func init(editor_interface: EditorInterface):
	self.editor_interface = editor_interface
	docked = true

func _on_RefreshButton_pressed():
	if docked:
		self.selected_path = editor_interface.get_selected_path()

func set_selected_path(path: String):	
	selected_path = path
	folder_path_input.text = path
	
	if not docked: return
	
	files.clear()
	file_list.clear()
	var fs_dir := editor_interface.get_resource_filesystem().get_filesystem_path(path)
	for i in range(fs_dir.get_file_count()):
		var filename = fs_dir.get_file(i)
		var filetype = fs_dir.get_file_type(i)
		file_list.add_item(filename)
		files.append({ "filename": filename, "filepath": fs_dir.get_file_path(i), "filetype": filetype })
	
	_hide_preview()


func _on_FileList_item_selected(index: int):
	if not docked: return
	
	var file: Dictionary = files[index]	
	_show_preview(file["filepath"])


func _show_preview(file_path: String):
	viewport_container.visible = false
	debug_label.visible = false
	
	var resource = load(file_path)
	if resource is PackedScene:
		var instance = resource.instance(PackedScene.GEN_EDIT_STATE_DISABLED)
		instance.set_process(false)
		instance.set_process_input(false)
		_show_viewport_preview(instance)
	else:
		debug_label.visible = true
		debug_label.text = "Sorry, I don't know how to preview a %s" % resource.get_class()
		
func _show_viewport_preview(instance):
	if viewport_container.set_instance(instance):
		viewport_container.visible = true
		debug_label.visible = false
	else: 
		debug_label.visible = true
		debug_label.text = "Sorry, I don't know how to preview a %s" % instance.get_class()
		instance.queue_free()		
	
func _hide_preview():
	viewport_container.visible = false
	viewport_container.clear_instance()
	debug_label.visible = true
	debug_label.text = ""
