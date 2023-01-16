extends Button

var icon_max = preload("res://window-maximize-solid.svg")
var icon_min = preload("res://window-restore-solid.svg")

var scale = 0.5

var state = false

var screensizeMemory = OS.get_window_size()/2

func _on_Maximise_pressed():
	if OS.get_window_position() != Vector2(0,0):
		OS.set_window_position(Vector2(0,0))
		OS.set_window_size(OS.get_screen_size())
		icon = icon_min
		state = false
	else:
		OS.set_window_position(Vector2(100,100))
		scale = 0.5
		OS.set_window_size(screensizeMemory)
		icon = icon_max
		state = true

func _process(_delta):
	scale = OS.get_window_size()/OS.get_screen_size()
	
	if state == false:
		hint_tooltip = "Restore"
	else:
		hint_tooltip = "Maximize"
