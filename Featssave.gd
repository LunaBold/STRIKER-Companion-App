extends Control

var slot = preload("res://FeatSlot.tscn")

var startingFeats = 3

func save():
	var savearray = []
	savearray.append(name)
	for i in $Boarder/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer.get_children():
		savearray.append(i.get_child(0).get_child(0).Name)
	var save_dict = {
		"filename" : get_filename(),
		"feats" : savearray
	}
	return save_dict

func Load():
	_on_Milestones_value_changed(0)


func _on_Milestones_value_changed(value):
	var slotcount = $Boarder/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer.get_child_count()
	if slotcount > startingFeats + (value*$"../../../..".config[5]):
		while slotcount > startingFeats + (value*$"../../../..".config[5]):
			$Boarder/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer.get_child(slotcount-1).queue_free()
			slotcount -= 1
	if slotcount < startingFeats + (value*$"../../../..".config[5]):
		while slotcount < startingFeats + (value*$"../../../..".config[5]):
			var newSlot = slot.instance()
			$Boarder/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer.add_child(newSlot)
			newSlot.get_child(0).get_child(0).CreateList()
			slotcount += 1
