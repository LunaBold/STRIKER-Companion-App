extends Panel

var dragging = false
var start_pos = Vector2(0,0)

func _on_Move_Window_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			dragging = !dragging
			start_pos = get_global_mouse_position()*$"../Maximise".scale

func _process(_delta):
	if dragging and $"../Maximise".state == true:
		OS.set_window_position(OS.get_window_position() + (get_global_mouse_position()*$"../Maximise".scale) - start_pos)
