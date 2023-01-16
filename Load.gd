extends Button

var sysSlot = preload("res://SystemSlot.tscn")

var path 
func _ready():
	if OS.has_feature("standalone"):
		path = OS.get_executable_path().get_base_dir()
	else:
		path = OS.get_user_data_dir()
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir("Save Files")


func _on_Load_pressed():
	$"../LoadSave".popup()
	$"../LoadSave".set_current_dir("%s/Save Files" % path)
	
func Load(saveSelection):
	var save_file = File.new()
	if not save_file.file_exists(saveSelection):
		return
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	
	var getname = saveSelection
	getname = Array(saveSelection.split("/"))
	getname = getname[getname.size()-2]
	$"../SaveDiag/Control/LineEdit".text = getname
	
	save_file.open(saveSelection, File.READ)
	var featslist = []
	while save_file.get_position() < save_file.get_len():
		var node_data = parse_json(save_file.get_line())
		var new_object
		if ResourceLoader.exists(node_data["filename"]):
			new_object = load(node_data["filename"]).instance()
			get_node(node_data["parent"]).add_child(new_object)
			if not new_object.is_class("Control"):
				new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
			else:
				new_object.rect_position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		var chname = ""
		var plname = ""
		var mename = ""
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			match i:
				"PlayerName":
					chname = node_data[i]
				"CharName":
					plname = node_data[i]
				"MechName":
					mename = node_data[i]
				"module_name":
					new_object.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0).text = node_data[i]
					new_object.node_name = node_data[i]
				"image":
					var img_file = File.new()
					var fname = Array(save_file.get_path().split("/"))
					fname = fname[fname.size()-2]
					print(fname)
					img_file.open("%s/Save Files/%s/%s.STKRimg" % [path, fname, node_data.get("imgname")], File.READ)
					var img_dat = img_file.get_var(true)
					var txt = ImageTexture.new()
					txt.create_from_image(img_dat)
					
					var targ
					if node_data.get("imgname") == "Mech":
						targ = $"../../TabContainer/Mecha/MechImage"
					else:
						targ = $"../../TabContainer/Character/PilotImage"
					
					targ.texture_normal = txt
					targ.texture_pressed = txt
					targ.texture_focused = txt
					targ.texture_hover = txt
					targ.texture_disabled = txt
					img_file.close()
				"stats":
					var target = null
					match node_data[i][0]:
						"Attributes":
							target = $"../../TabContainer/Character/Attributes"
						"Skills":
							target = $"../../TabContainer/Character/Skills"
						"Levels":
							target = $"../../TabContainer/Character/Levels"
							print(node_data[i])
							$"../../TabContainer/Character/Feats"._on_Milestones_value_changed(node_data[i][1])
					if target != null:
						var statlist = target.get_child(0).get_child(0).get_child(0)
						for n in statlist.get_children():
							if n.get_child_count() > 0:
								n.get_child(1).value = node_data[i][n.get_index()-1]
				"feats":
					featslist = node_data[i]
					featslist.pop_front()
				"Systems":
					new_object.systems = node_data[i]
				"size":
					new_object._size = node_data[i]
				"HP":
					new_object.get_node("MarginContainer/VBoxContainer/HP/PanelContainer/HBoxContainer/Value").max_value = node_data[i]
					new_object.get_node("MarginContainer/VBoxContainer/HP/PanelContainer/HBoxContainer/Value").value = node_data[i]
				"syshp":
					new_object._hpArray = node_data[i]
				"sysammo":
					new_object._AmmoArray = node_data[i]
				"focus":
					$"../../..".FocusPoints = int(node_data[i])
				_:
					pass
		$"../../..".setName(chname, plname, mename)
	save_file.close()
	for i in $"../../TabContainer/Character/Feats/Boarder/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer".get_children():
		i.get_child(0).get_child(0).select(get_node("/root/Control").featsList.keys().find(featslist[i.get_index()])+1)
		i.get_child(0).get_child(0)._on_OptionButton_item_selected(i.get_child(0).get_child(0).get_selected())
