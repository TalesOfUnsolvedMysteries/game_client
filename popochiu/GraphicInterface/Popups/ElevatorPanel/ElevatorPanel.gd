extends Control
# Hace que el ascensor vaya a diferentes pisos dentro del edificio.
# TODO: ¿Poner un Tween para cuando aparece y desaparece el panel?
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

onready var _buttons: Control = find_node('Buttons')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	for b in _buttons.get_children():
		b.connect('floor_selected', self, 'hide')
	
	G.connect('elevator_panel_requested', self, '_open')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _open() -> void:
	for b in _buttons.get_children():
		b.set_pressed_no_signal(false)
#		if b.go_to == E.current_room.script_name:
#			b.set_pressed_no_signal(true)
	
	show()
