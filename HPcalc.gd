extends HBoxContainer

var HPmax = 0

func _process(_delta):
	var count = 0
	for i in $"../../..".systems:
		if i == "Empty":
			count += 2
	HPmax = $"../Size/PanelContainer/HBoxContainer/Value".value + count
	$PanelContainer/HBoxContainer/MaxHP.text = str(HPmax)
	$PanelContainer/HBoxContainer/Value.max_value = HPmax
