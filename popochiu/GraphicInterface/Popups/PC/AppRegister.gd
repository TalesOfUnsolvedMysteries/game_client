extends Panel

onready var _body: VBoxContainer = find_node('Body')


func _ready() -> void:
	for row in _body.get_children():
		for field in row.get_children():
			if field is OptionButton:
				_add_arcanes(field)


func _add_arcanes(ob: OptionButton) -> void:
	for a in Globals.ARCANES:
		ob.add_item(a)
