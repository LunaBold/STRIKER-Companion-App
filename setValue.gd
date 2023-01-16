extends RichTextLabel

func _process(_delta):
	if $"..".get_node_or_null("Attributes") != null:
		bbcode_text = "[rainbow freq=0.3 sat=0.6 val=1]Resolve: %s/%s[/rainbow]" % [$"../../../..".FocusPoints, $"../Attributes/Boarder/MarginContainer/VBoxContainer/HBoxContainer4/Focus".value + $"../Attributes/Boarder/MarginContainer/VBoxContainer/HBoxContainer/Fitness".value]
