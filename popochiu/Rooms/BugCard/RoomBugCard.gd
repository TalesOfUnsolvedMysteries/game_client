tool
extends PopochiuRoom

onready var _interface = $Interface
onready var _bug_name = _interface.find_node('Name')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	G.done()
	G.hide_interface()
	
	if Globals.main_mx_play:
		A.stop('mx_main', 0, false, true)
		Globals.main_mx_play = false
	
	C.player.position = Vector2(-80, 6)
	C.player.scale = Vector2(1.5, 1.5)
	
	_bug_name.text = Globals.bug_name if Globals.bug_name else 'Panchita'
	# Utils.take_screenshot()


func on_room_transition_finished() -> void:
	pass


func on_room_exited() -> void:
	.on_room_exited()
	C.player.scale = Vector2(1.0, 1.0)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
