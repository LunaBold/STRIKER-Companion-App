extends Control

var mouse_offset
var following = false
var window_position
var window_size
var distance_to_edge
var oldscale

func _ready():
	distance_to_edge = OS.window_size - rect_global_position

func _on_Handler_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			mouse_offset = get_local_mouse_position()
			window_position = OS.window_position
			window_size = OS.window_size
			following = !following

func _process(_delta):
	if $"../MarginContainer/Buttons/Maximise".state:
		visible = true
	else:
		visible = false
	if following:
		OS.window_size = (get_global_mouse_position()*$"../MarginContainer/Buttons/Maximise".scale) + distance_to_edge - mouse_offset
		$"../MarginContainer/Buttons/Maximise".screensizeMemory = OS.window_size
