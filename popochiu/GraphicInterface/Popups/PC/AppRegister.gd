extends Panel
# Controla la aplicación para mostrar el registro de habitantes del edificio.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

const DATA := preload('res://popochiu/Data.gd')

onready var _body: VBoxContainer = find_node('Body')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	for row in _body.get_children():
		for field in row.get_children():
			if field is OptionButton:
				_add_options(field, DATA[field.name.to_upper()])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _add_options(ob: OptionButton, options: Array) -> void:
	for a in options:
		ob.add_item(a)
