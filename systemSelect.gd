extends Button

export (NodePath) var connection

func _ready():
	var _Connect = connect("pressed", self, "_on_Pressed")

func _on_Pressed():
	for i in $"../../PanelContainer/ScrollContainer".get_children():
		i.visible = false
	get_node(connection).visible = true
	for i in get_parent().get_children():
		i.pressed = false
	pressed = true
