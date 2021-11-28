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
	
	if not Globals.state.has(script_name):
		# Establecer el estado por defecto de la habitación
		Globals.state[script_name] = {
			ENGINE_ROOM_UNLOCKED = false
		}
		get_hotspot('EngineRoom').disable(false)
	else:
		if not Globals.state[script_name].ENGINE_ROOM_UNLOCKED:
			get_hotspot('EngineRoom').disable(false)
		else:
			get_hotspot('EngineRoom').enable(false)
			get_prop('EngineRoomDoor').disable(false)

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
		E.run(['Player: Está bloquiao'])


func open_engine_room() -> void:
	Globals.state[script_name].ENGINE_ROOM_UNLOCKED = true
	
	yield(E.run([
		C.walk_to_clicked(),
		'Player: Eeeeeeeee!!!!',
		'Player: Ya puedo entrar a la sala de motores',
		I.remove_item('KeyEngineRoom'),
		get_hotspot('EngineRoom').enable(),
		get_prop('EngineRoomDoor').disable()
	]), 'completed')
	


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
