extends Button


func _on_Rest_pressed():
	$"../../../..".FocusPoints = min($"../../../..".FocusPoints+1, $"../Attributes/Boarder/MarginContainer/VBoxContainer/HBoxContainer4/Focus".value + $"../Attributes/Boarder/MarginContainer/VBoxContainer/HBoxContainer/Fitness".value)
