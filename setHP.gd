extends HBoxContainer


var MyParent = null
var AmmoLink = null

func _on_HP_value_changed(value):
	MyParent.HP = str(value)


func _on_Ammo_value_changed(value):
	MyParent.Ammo = str(value)
