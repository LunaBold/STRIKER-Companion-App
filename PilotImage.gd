extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PilotImage_pressed():
	$"../FileDialog".popup_centered()


func save():
	var save_dict = {
		"filename" : get_filename(),
		"imgname" : "Pilot",
		"parent" : get_parent().get_path(),
		"pos_x" : rect_position.x, # Vector2 is not supported by JSON
		"pos_y" : rect_position.y,
		"image" : texture_normal.get_data()
	}
	return save_dict
