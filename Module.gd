extends PanelContainer

var systems = []
var scene = preload("res://SystemSlot.tscn")
var ArmSlot = preload("res://ArmSlot.tscn")
var WepSlot = preload("res://WepSlot.tscn")
var UtiSlot = preload("res://UtiSlot.tscn")
var AmmSlot = preload("res://AmmSlot.tscn")
var lastSelected = 0
var loaded = false

export var node_name = "Module Name"
var _hpArray = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var _AmmoArray = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var _size = 3

var power = 0
var reactors = 0
var drive = 0
var totalMass = 0
var totalVolume = 0
var size = 0
var evasion = 0

func _process(_delta):
	if loaded == false and _hpArray != null and _AmmoArray != null:
		while _hpArray.size() < 20:
			_hpArray.append(0)
		while _AmmoArray.size() < 20:
			_AmmoArray.append(0)
		while systems.size() < 20:
			systems.append("Empty")
		for i in _size:
			var module = scene.instance()
			module.get_child(0).get_child(0).myPar = self
			$MarginContainer/VBoxContainer/ScrollContainer/Module.add_child(module)
			module.get_child(0).get_child(0).CreateList();
			module.get_child(0).get_child(0).HP = _hpArray[i]
			module.get_child(0).get_child(0).Ammo = _AmmoArray[i]
			if systems[i] != "Empty":
				module.get_child(0).get_child(0).send_index(systems[i])
			module.get_child(0).get_child(0).text = systems[i]
		
		$MarginContainer/VBoxContainer/Size/PanelContainer/HBoxContainer/Value.value = _size
		while systems.size() > _size:
			systems.pop_back()
		_hpArray = null
		_AmmoArray = null
		_size = null
		loaded = true
		$MarginContainer/VBoxContainer/ModuleName/PanelContainer/LineEdit.text = node_name
		return
	elif loaded == false:
		loaded = true
		$MarginContainer/VBoxContainer/Size/PanelContainer/HBoxContainer/Value.value = _size
		while systems.size() > _size:
			systems.pop_back()
		return
		
	var usedSpace = 0
	var moduleSize = $MarginContainer/VBoxContainer/Size/PanelContainer/HBoxContainer/Value.value
	for i in range(0, systems.size()):
		var j = $MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i)
		systems[i] = j.get_child(0).get_child(0).Name
	
	power = 0
	reactors = 0
	drive = 0
	totalMass = 0
	totalVolume = 0
	for i in range(0, systems.size()):
		usedSpace += max(int(get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", 0])[1])-1, 0)
		if int($MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i).get_child(0).get_child(0).HP) > 0 and $MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i).get_child(0).get_child(1).pressed == true:
			if get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", "","","",""])[2] == "Reactor":
				reactors += int(get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", 0,0,0,0])[4])
			elif get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", "","","",""])[2] == "Ammo":
				pass
			else:
				power += int(get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", 0,0,0,0])[4])
			if get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", "","","",""])[2] == "Drive":
				drive += int(get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", 0,0,0,0,0,0,0,0])[7])
		size = $MarginContainer/VBoxContainer/Size/PanelContainer/HBoxContainer/Value.value
		totalMass += int(get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", 0,0,0,0,0,0,0,0])[5])
		totalVolume += int(get_node("/root/Control").systemsList.get(systems[i], ["FAILSAFE", 0,0,0,0,0,0,0,0])[1])
	totalMass += size
	
	if systems.size()+usedSpace < moduleSize:
		systems.append("Empty")
		var module = scene.instance()
		module.get_child(0).get_child(0).myPar = self
		$MarginContainer/VBoxContainer/ScrollContainer/Module.add_child(module)
		module.get_child(0).get_child(0).CreateList()
	
	if systems.size()+usedSpace > moduleSize:
		var where = -1
		if is_instance_valid(lastSelected) == true:
			where = systems.find("Empty",lastSelected.get_index())
		if where == -1:
			where = systems.find("Empty",0)
			if where == -1:
				where = systems.size()-1
		else:
			lastSelected.get_index()
		systems.pop_at(where)
		$MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(where).free()

func _on_Select(id, option):
	if option == "Empty":
		lastSelected = id
		id.get_child(0).get_child(0).text = "Empty"
		return
	var emptySlots = systems.size()+1
	for i in systems:
		if i != "Empty":
			emptySlots -= 1
	var addSlots = 0
	if id.get_child(0).get_child(0).text != "Empty":
		addSlots = int(get_node("/root/Control").systemsList[id.get_child(0).get_child(0).text][1])
	if emptySlots + addSlots <= int(get_node("/root/Control").systemsList.get(option)[1]):
		id.get_child(0).get_child(0).text = "Empty"
	else:
		id.get_child(0).get_child(0).text = option
	lastSelected = id
	if loaded == true:
		if get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, "Null")[2] == "Armour":
			var hpvar = int(get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, [0,0,0,0,0,0,0,0])[3])+int(get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, [0,0,0,0,0,0,0,0])[5])
			print(hpvar)
			id.get_child(0).get_child(0).HP = hpvar
		else:
			id.get_child(0).get_child(0).HP = get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, [0,0,0,0,0,0,0,0])[5]
		id.get_child(0).get_child(0).Ammo = get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, [0,0,0,0,0,0,0,0])[4]
		id.get_child(0).get_child(0).ID = get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, [0,0,0,0,0,0,0,0])[0]
		if "Weapon" in get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, "Null")[2] and not "Melee" in get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, "Null")[2]:
			id.get_child(0).get_child(0).maxammo = int(get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, [0,0,0,0,0,0,0,0,0,0,0])[8])
		else:
			id.get_child(0).get_child(0).maxammo = 0
		if "Ammo" in get_node("/root/Control").systemsList.get(id.get_child(0).get_child(0).text, "Null")[2]:
			id.get_child(0).get_child(0).Ammoboxmax = 0
			id.get_child(0).get_child(0).AmmoLink = 0

func _on_Pressed():
	var armour = get_node("/root/Control/MarginContainer/TabContainer/Mecha/infoPanel/PanelContainer/ScrollContainer/Armour")
	var weapon = get_node("/root/Control/MarginContainer/TabContainer/Mecha/infoPanel/PanelContainer/ScrollContainer/Weapons")
	var utility = get_node("/root/Control/MarginContainer/TabContainer/Mecha/infoPanel/PanelContainer/ScrollContainer/Utilities")
	var ammo = get_node("/root/Control/MarginContainer/TabContainer/Mecha/infoPanel/PanelContainer/ScrollContainer/Ammo")
	
	get_node("/root/Control/MarginContainer/TabContainer/Mecha/infoPanel/Boarder/Label").text = "Showing details for: %s" % node_name
	
	while armour.get_child_count() > 2:
		armour.get_child(2).free()
	while weapon.get_child_count() > 2:
		weapon.get_child(2).free()
	while utility.get_child_count() > 2:
		utility.get_child(2).free()
	while ammo.get_child_count() > 2:
		ammo.get_child(2).free()

	for i in range(0, systems.size()):
		var moduleArray = get_node("/root/Control").systemsList.get(systems[i], [0,0,"Type",0,0,0,0,0,0])
		if "Weapon" in moduleArray[2] and not "Melee" in moduleArray[2]:
			moduleArray[2] = "Weapon"
		elif "Melee" in moduleArray[2]:
			moduleArray[2] = "Melee"
		match moduleArray[2]:
			"Armour":
				var slot = ArmSlot.instance()
				armour.add_child(slot)
				slot.MyParent = $MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i).get_child(0).get_child(0)
				slot.get_node("Type").text = systems[i]
				slot.get_node("HP").value = int(slot.MyParent.HP)
				var mxhp = int(moduleArray[3])+int(moduleArray[5])
				slot.get_node("HP").max_value = mxhp
				slot.get_node("Max").text = str(mxhp)
				slot.get_node("DR").text = moduleArray[6]
				slot.get_node("Effect").text = moduleArray[7]
			"Melee":
				var slot = WepSlot.instance()
				weapon.add_child(slot)
				slot.MyParent = $MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i).get_child(0).get_child(0)
				slot.get_node("Type").text = systems[i]
				slot.get_node("HP").value = int(slot.MyParent.HP)
				slot.get_node("HP").max_value = int(moduleArray[5])
				slot.get_node("Max").text = moduleArray[5]
				slot.get_node("Damage").text = moduleArray[3]
				slot.get_node("Range").text = moduleArray[6]
				slot.get_node("Effect").text = moduleArray[7]
			"Weapon":
				var slot = WepSlot.instance()
				weapon.add_child(slot)
				slot.MyParent = $MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i).get_child(0).get_child(0)
				slot.get_node("Type").text = systems[i]
				slot.get_node("HP").value = int(slot.MyParent.HP)
				slot.get_node("HP").max_value = int(moduleArray[5])
				slot.get_node("Max").text = moduleArray[5]
				slot.get_node("Damage").text = moduleArray[3]
				slot.get_node("Range").text = moduleArray[6]
				slot.get_node("Effect").text = moduleArray[7]
			"Utility", "Reactor", "Drive":
				var slot = UtiSlot.instance()
				utility.add_child(slot)
				slot.MyParent = $MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i).get_child(0).get_child(0)
				slot.get_node("Type").text = systems[i]
				slot.get_node("HP").value = int(slot.MyParent.HP)
				slot.get_node("HP").max_value = int(moduleArray[5])
				slot.get_node("Max").text = moduleArray[5]
				slot.get_node("Damage").text = moduleArray[4]
				slot.get_node("Range").text = moduleArray[6]
				slot.get_node("Effect").text = moduleArray[7]
			"Ammo":
				var slot = AmmSlot.instance()
				ammo.add_child(slot)
				slot.MyParent = $MarginContainer/VBoxContainer/ScrollContainer/Module.get_child(i).get_child(0).get_child(0)
				slot.get_node("Type").text = slot.MyParent.ammoname + " " + systems[i]
				slot.get_node("HP").value = int(slot.MyParent.HP)
				slot.get_node("HP").max_value = int(moduleArray[5])
				slot.get_node("Max").text = moduleArray[5]
				slot.get_node("Ammo").value = int(slot.MyParent.Ammo)
				if slot.MyParent.AmmoLink == null:
					slot.get_node("Ammo").max_value = int(moduleArray[4])
					slot.get_node("AmmoMax").text = moduleArray[4]
					print("nope")
				else:
					slot.get_node("Ammo").max_value = slot.MyParent.Ammoboxmax
					slot.get_node("AmmoMax").text = String(slot.MyParent.Ammoboxmax)
					print("heck")
				slot.get_node("Effect").text = moduleArray[7]
			_:
				pass

func save():
	var hparray = []
	var ammoarray = []
	for i in $MarginContainer/VBoxContainer/ScrollContainer/Module.get_children():
		hparray.append(i.get_node("SystemSlot/OptionButton").HP)
		ammoarray.append(i.get_node("SystemSlot/OptionButton").Ammo)
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : rect_position.x, # Vector2 is not supported by JSON
		"pos_y" : rect_position.y,
		"module_name" : $MarginContainer/VBoxContainer/ModuleName/PanelContainer/LineEdit.text,
		"Systems" : systems,
		"size" : $MarginContainer/VBoxContainer/Size/PanelContainer/HBoxContainer/Value.value,
		"HP" : $MarginContainer/VBoxContainer/HP/PanelContainer/HBoxContainer/Value.value,
		"syshp" : hparray,
		"sysammo" : ammoarray
	}
	return save_dict
