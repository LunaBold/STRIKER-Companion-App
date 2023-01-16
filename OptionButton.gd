extends OptionButton

signal select(id, option)
onready var myPar = $"../../../../../../.."
onready var popup: PopupMenu = get_child(0)
var HP = 1
var Ammo = 1
var Ammoboxmax = 1
var Name = "Empty"
var ID = ""
var AmmoLink = null
var ammoname = "Unlinked"
var maxammo = 0

func CreateList():
	add_item("Empty")
	var submenu_Items = []
	for i in get_node("/root/Control").systemsList:
		var j = get_node("/root/Control").systemsList[i][2]
		if not j in submenu_Items:
			submenu_Items.append(j)
	for i in submenu_Items:
		var submenulist = []
		var submenulistslots = []
		for j in get_node("/root/Control").systemsList:
			if get_node("/root/Control").systemsList[j][2] == i:
				submenulist.append(j)
				if int(get_node("/root/Control").systemsList[j][1]) > 1:
					submenulistslots.append("Requires: %s slots" % get_node("/root/Control").systemsList[j][1])
				else:
					submenulistslots.append("Requires: %s slot" % get_node("/root/Control").systemsList[j][1])
		var newSub = PopupMenu.new()
		popup.add_child(newSub)
		popup.add_submenu_item(i, newSub.get_name())
		for n in submenulist:
			newSub.add_item(n)
			newSub.set_item_tooltip(newSub.get_item_count()-1, submenulistslots[newSub.get_item_count()-1])
		var _connec = newSub.connect("index_pressed", self, "_select", [newSub])
	
	var _connec = connect("select", myPar, "_on_Select")
	var _connec2 = popup.connect("index_pressed", self, "_select", [popup])

func _select(id, source):
	send_index(source.get_item_text(id))

func _process(_delta):
	text = get_item_text(get_selected_id())
	if int(HP) == 0 && Name != "Empty":
		text = Name + " [BROKEN]"
	else:
		text = Name

func _on_OptionButton_item_selected(index):
	send_index(get_item_text(index))

func send_index(index):
	if emit_signal("select", $"../..", index) == false:
		push_error("Something horrible went wrong with OptionsButton")
	else:
		Name = text

func _on_ToolButton_value_changed(value):
	$"../..".get_parent().move_child($"../..", $"../..".get_index()+(value*-1))
	$"../../Node2D/ToolButton".value = 0


func _on_SystemSlot_mouse_entered():
	get_node("/root/Control").hovered = self
