tool
extends PopochiuRoom

onready var pc: PanelContainer = find_node('PCContainer')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	match C.player.last_room:
		'FirstFloor':
			C.player.position = get_hotspot('FirstFloor').walk_point
		'EngineRoom':
			C.player.position = get_hotspot('EngineRoom').walk_point

	if !Globals.main_mx_play:
		A.play_music('mx_main', false)
		Globals.main_mx_play = true

func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func use_pc() -> void:
	if Globals.state.has('Lobby-PC_UNLOCKED') and Globals.state['Lobby-PC_UNLOCKED']:
		yield(E.run([
			'Player: Uy ya prendió',
			A.play({cue_name = 'sfx_pc_startup',is_in_queue = true})]), 'completed')
		pc.show()
	else:
		C.player_say('Está bloqueao', false)
		G.done()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
