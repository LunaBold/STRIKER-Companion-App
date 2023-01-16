extends Label


func _process(_delta):
	var totalPower = 0
	var totalReactors = 0
	for i in get_tree().get_nodes_in_group("Persist"):
		totalPower += i.power
		totalReactors += i.reactors
	text = "Power Generated: %s/%s" % [totalPower, totalReactors]
	if totalPower > totalReactors:
		$"../ColorRect".color = Color(1,0,0,0.737255)
	else:
		$"../ColorRect".color = Color(1,0,0,0)
