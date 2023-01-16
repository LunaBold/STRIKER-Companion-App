extends Label


func _process(_delta):
	var drive = 0.0
	var totalMass = 0.0
	for i in get_tree().get_nodes_in_group("Persist"):
		drive += i.drive
		totalMass += i.totalMass
	totalMass = max(totalMass, 0.01)
	var math = floor($"../../../../..".config[0]*(drive/totalMass))
	text = "Movement Points: %s" % [math]
