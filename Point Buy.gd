extends Label


export (Array, NodePath) var stats := []

export var startPoints = 60
var pointsPerLevel = 1
var maxPoints = startPoints
var currentPoints = 0

func _ready():
	currentPoints = startPoints

func _process(_delta):
	text = str(currentPoints)
	var count = int(0)
	for i in stats:
		count += get_node(i).value*(get_node(i).value+1)/2
	var milestone = get_node_or_null("../../../../../../Levels/Boarder/MarginContainer/VBoxContainer/HBoxContainer/Milestones")
	var milestoneVar = 0
	if milestone != null:
		milestoneVar = milestone.value
	currentPoints = (maxPoints-count)+(pointsPerLevel*milestoneVar)
	if currentPoints < 0:
		$"../../ColorRect".color = Color(1,0,0,0.737255)
	else:
		$"../../ColorRect".color = Color(1,0,0,0)
