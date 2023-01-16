extends Button

var linked = null

func _input(event):
	if event is InputEventMouseButton and get_node("/root/Control").linkingstate == true:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			linked = get_node("/root/Control").hovered
			if linked.maxammo != 0:
				$"..".MyParent.Ammoboxmax = linked.maxammo
				$"..".MyParent.ammoname = linked.Name
				$"..".ammoname = linked.Name
		else:
			pass
		get_node("/root/Control").linkingstate = false
		$"..".MyParent.myPar._on_Pressed()

func _pressed():
	get_node("/root/Control").linkingstate = true
