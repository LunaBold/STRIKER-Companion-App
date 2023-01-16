extends Control

enum Attributes {
	Fitness = 0
	Agility = 0
	Perception = 0
	Focus = 0
	Intellect = 0
	Panache = 0
}
enum Skills{
	Energy = 0
	Ballistics = 0
	Missiles = 0
	CloseCombat = 0
	Dodge = 0
	Piloting = 0
	Technology = 0
	Mechanics = 0
	Diplomacy = 0
	Athletics = 0
	Warfare = 0
	Coercion = 0
	Medicine = 0
}

var attributes = []
var skills = []

var FocusPoints = 0

var systemsList = {}
var featsList = {}

var path

var hovered = null
var linkingstate = null

var config = [
	50, #Movement Mod
	20, #Lumbering Mod
	10, #Skills Per Level
	5, #Attributes Per Level
	60, #Skills Per Level
	60, #Attributes Per Level
	1, #Feats Per Level
	3, #Starting Feats
	5 #Default Slots
]

func _ready():
	if OS.has_feature("standalone"):
		path = OS.get_executable_path().get_base_dir()
	else:
		path = OS.get_user_data_dir()
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir("Data")
	load_file()

func load_file():
	#load config
	var configfile = ConfigFile.new()
	var checkconfigfile = File.new()
	if not checkconfigfile.file_exists(path+"/config.ini"):
		configfile.set_value("Settings", "#Movement-Mod", 50)
		configfile.set_value("Settings", "#Lumbering-Mod", 20)
		configfile.set_value("Settings", "#Skills-Per-Level", 10)
		configfile.set_value("Settings", "#Attributes-Per-Level", 5)
		configfile.set_value("Settings", "#Starting-Skills", 60)
		configfile.set_value("Settings", "#Starting-Attributes", 60)
		configfile.set_value("Settings", "#Feats-Per-Level", 1)
		configfile.set_value("Settings", "#Starting-Feats", 3)
		configfile.set_value("Settings", "#Default-Slots", 5)
		configfile.save(path+"/config.ini")
		configfile = null
	
	configfile = ConfigFile.new()
	configfile.load(path+"/config.ini")
	print("loading ini")
	var jn = 0
	config[jn] = configfile.get_value("Settings", "#Movement-Mod", 50)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Lumbering-Mod", 20)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Skills-Per-Level", 10)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Attributes-Per-Level", 5)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Starting-Skills", 60)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Starting-Attributes", 60)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Feats-Per-Level", 1)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Starting-Feats", 3)
	jn += 1
	config[jn] = configfile.get_value("Settings", "#Default-Slots", 5)
	jn += 1
	$MarginContainer/TabContainer/Character/Attributes/Boarder/Control/PanelContainer/HBoxContainer6/StatPoints.maxPoints = config[5]
	$MarginContainer/TabContainer/Character/Attributes/Boarder/Control/PanelContainer/HBoxContainer6/StatPoints.pointsPerLevel = config[3]
	$MarginContainer/TabContainer/Character/Skills/Boarder/Control/PanelContainer/HBoxContainer6/StatPoints.maxPoints = config[4]
	$MarginContainer/TabContainer/Character/Skills/Boarder/Control/PanelContainer/HBoxContainer6/StatPoints.pointsPerLevel = config[2]
	$MarginContainer/TabContainer/Mecha/Drive2/Label.mult = config[1]
	$MarginContainer/TabContainer/Mecha/Drive3/Label.mult = config[1]
	#load systems/feats
	var dir = Directory.new()
	var files = []
	$MarginContainer/TabContainer/Character/Feats.startingFeats = config[7]
	for i in get_tree().get_nodes_in_group("Persist"):
		i._size = get_node("/root/Control").config[8]
	dir.open(path+"/Data")
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	
	dir.list_dir_end()
	
	for i in files:
		var file = File.new()
		file.open("%s/%s" % [path+"/Data", i], File.READ)
		if file.get_path().ends_with(".systems"):
			while not file.eof_reached():
				var line = file.get_line()
				var commentCheck = line.split("| ")[0]
				if commentCheck.find("#") == 0:
					continue
				var Name = line.split("| ")[1]
				var Slots = line.split("| ")[2]
				var Type = line.split("| ")[3]
				var DamHP = line.split("| ")[4]
				var PowDR = line.split("| ")[5]
				var Mass = line.split("| ")[6]
				var RANGE = line.split("| ")[7]
				var AddEff = line.split("| ")[8]
				var AmmoCount
				if "Weapon" in Type and not "Melee" in Type:
					AmmoCount = line.split("| ")[9]
					systemsList.merge({Name: [commentCheck, Slots, Type, DamHP, PowDR, Mass, RANGE, AddEff, AmmoCount]})
				else:
					systemsList.merge({Name: [commentCheck, Slots, Type, DamHP, PowDR, Mass, RANGE, AddEff]})
		if file.get_path().ends_with(".feats"):
			while not file.eof_reached():
				var line = file.get_line()
				var commentCheck = line.split("| ")[0]
				if commentCheck.find("#") == 0:
					continue
				var Name = line.split("| ")[1]
				var Action = line.split("| ")[2]
				var Effect = line.split("| ")[3]
				var Req = line.split("| ")[4]
				featsList.merge({Name: [commentCheck, Action, Effect, Req]})
		file.close()
	$MarginContainer/TabContainer/Character/Feats.Load()

func _process(_delta):
	var charsheet = $MarginContainer/TabContainer/Character
	if charsheet.get_node_or_null("Attributes") != null and charsheet.get_node_or_null("Skills") != null and charsheet.get_node_or_null("Levels") != null:
		for i in $MarginContainer/TabContainer/Character/Attributes/Boarder/MarginContainer/VBoxContainer.get_children():
			if i.get_child_count() > 0:
				attributes.append(i.get_child(1).value)
		for i in $MarginContainer/TabContainer/Character/Skills/Boarder/MarginContainer/VBoxContainer.get_children():
			if i.get_child_count() > 0:
				skills.append(i.get_child(1).value)
	if linkingstate == true:
		$MarginContainer/TabContainer/Mecha/infoPanel/linkstatepopup.visible = true
		$MarginContainer/TabContainer/Mecha/infoPanel/linkstatepopup/Label.text = "Right click target system to link to ammo.\nLeft click to cancel.\nCurrently selecting %s" % hovered.Name
	else:
		$MarginContainer/TabContainer/Mecha/infoPanel/linkstatepopup.visible = false

func setName(chname: String, plname: String, mename: String):
	chname = chname.strip_escapes()
	plname = plname.strip_escapes()
	mename = mename.strip_escapes()
	
	chname = chname.strip_edges()
	plname = plname.strip_edges()
	mename = mename.strip_edges()
	
	if plname != "":
		$MarginContainer/TabContainer/Character/PlayerName.text = plname
	if chname != "":
		$MarginContainer/TabContainer/Character/CharName.text = chname
	if mename != "":
		$MarginContainer/TabContainer/Mecha/MechName.text = mename

