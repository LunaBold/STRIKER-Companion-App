extends HBoxContainer


var MyParent = null
var ammoname = "Unlinked"

func initialise():
	if MyParent.ammoname != "":
		ammoname = MyParent.ammoname

func _on_HP_value_changed(value):
	MyParent.HP = str(value)


func _on_Ammo_value_changed(value):
	MyParent.Ammo = str(value)

func process():
	$Type.text = ammoname
	print($Type.text)
