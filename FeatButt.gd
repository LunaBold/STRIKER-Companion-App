extends OptionButton

var Name = "Empty"
var ID = ""


func CreateList():
	add_item("Empty")
	for i in get_node("/root/Control").featsList:
		add_item(i)


func _on_OptionButton_item_selected(_index):
	Name = text
	if text != "Empty":
		$"../Boarder2/ScrollContainer/VBoxContainer/RichTextLabel".text = get_node("/root/Control").featsList.get(text)[2]
		$"../Boarder2/ScrollContainer/VBoxContainer/HBoxContainer/RichTextLabel".text = "Actions: %s" % get_node("/root/Control").featsList.get(text)[1]
		$"../Boarder2/ScrollContainer/VBoxContainer/HBoxContainer/RichTextLabel2".text = get_node("/root/Control").featsList.get(text)[3]
	else:
		$"../Boarder2/ScrollContainer/VBoxContainer/RichTextLabel".text = ""
		$"../Boarder2/ScrollContainer/VBoxContainer/HBoxContainer/RichTextLabel".text = ""
		$"../Boarder2/ScrollContainer/VBoxContainer/HBoxContainer/RichTextLabel2".text = ""
