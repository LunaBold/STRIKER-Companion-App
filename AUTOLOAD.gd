extends Node


func _enter_tree():
	set("display/window/size/width", OS.get_screen_size().x)
	set("display/window/size/height", OS.get_screen_size().y)
	OS.vsync_enabled = true
	Engine.target_fps = 30
	OS.set_window_position(Vector2(0,0))
	OS.set_window_size(OS.get_screen_size())
	get_tree().get_root().set_transparent_background(true)
