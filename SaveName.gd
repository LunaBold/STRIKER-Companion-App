extends LineEdit

export var Name = ""
var default_text = ""

func _ready():
	default_text = text
	var _connecc1 = connect("focus_entered", self, "_gain_focus")
	var _connecc2 = connect("focus_exited", self, "_lose_focus")

func save():
	var save_dict = {
		"filename" : "doesntexist",
		Name : text
	}
	return save_dict

func _gain_focus():
	if text == default_text:
		text = ""

func _lose_focus():
	if text == "":
		text = default_text
