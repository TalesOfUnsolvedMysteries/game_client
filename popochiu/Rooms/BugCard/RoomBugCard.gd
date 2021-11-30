tool
extends PopochiuRoom

onready var _interface = $Interface
onready var _bug_name = _interface.find_node('Name')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	C.player.position = Vector2(-80, 6)
	C.player.scale = Vector2(1.5, 1.5)
	C.player.get_node('Sprite').set_flip_h(false)
	_bug_name.text = Globals.bug_name
	#Utils.take_screenshot()


func on_room_transition_finished() -> void:
	G.done()
	G.hide_interface()

func on_room_exited() -> void:
	.on_room_exited()
	C.player.scale = Vector2(1.0, 1.0)

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
