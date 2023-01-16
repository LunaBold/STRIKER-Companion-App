extends Label


export(NodePath) var Stat1 = null
export(NodePath) var Stat2 = null
var Combo

var _Stat1
var _Stat2

var _Stat1name
var _Stat2name

func _ready():
	Combo = get_parent().get_node("Label2")
	_Stat1name = get_node(Stat1).name
	_Stat2name = get_node(Stat2).name
	Combo.text = ("(%s + %s)" % [_Stat1name , _Stat2name])

func _process(_delta):
	_Stat1 = get_node(Stat1).value
	_Stat2 = get_node(Stat2).value
	text = String(_Stat1 + _Stat2)
