extends Button


func _on_Save_pressed():
	$"../SaveDiag".popup_centered()

func save_game(Filename):
	var save_file = File.new()
	var dir = Directory.new()
	var path 
	if OS.has_feature("standalone"):
		path = OS.get_executable_path().get_base_dir()
	else:
		path = OS.get_user_data_dir()
	dir.open(path)
	dir.make_dir("Save Files/%s" % Filename)
	save_file.open("%s/Save Files/%s/Main.save" % [path, Filename], File.WRITE)
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	var name_nodes = get_tree().get_nodes_in_group("Names")
	var stat_nodes = get_tree().get_nodes_in_group("Stats")
	var image_nodes = get_tree().get_nodes_in_group("Image")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data: Dictionary = node.call("save")
		node_data.merge({"focus" : $"../../..".FocusPoints})
		save_file.store_line(to_json(node_data))
	
	for node in name_nodes:
		var node_data: Dictionary = node.call("save")
		save_file.store_line(to_json(node_data))
	
	for node in stat_nodes:
		var node_data: Dictionary = node.call("save")
		save_file.store_line(to_json(node_data))
	
	for node in image_nodes:
		var node_data: Dictionary = node.call("save")
		save_file.store_line(to_json(node_data))
		if node_data.has("image"):
			var img_file = File.new()
			img_file.open("%s/Save Files/%s/%s.STKRimg" % [path, Filename, node_data.get("imgname")], File.WRITE)
			img_file.store_var(node.texture_normal.get_data(), true)
			print("succ!")
			print("%s/Save Files/%s/%s.STKRimg" % [path, Filename, node_data.get("imgname")])
			img_file.close()
	
	print("%s/Save Files/%s.save" % [path, Filename])
	save_file.close()
