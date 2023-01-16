extends Label

var mult = 20

func _process(_delta):
	var size = 0
	var totalMass = 0.0
	for i in get_tree().get_nodes_in_group("Persist"):
		totalMass += i.totalMass
		size += i.size
	text = "Total Mass: %s\nTotal Size: %s\nLumbering: %s" % [totalMass, size, float(totalMass+size)/mult]
