tool
extends PopochiuRoom

onready var pc: PanelContainer = $CanvasLayer/PC


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
	
	if not Globals.state.get('Lobby-ENGINE_ROOM_UNLOCKED'):
		get_hotspot('EngineRoom').disable(false)
	else:
		get_hotspot('EngineRoom').enable(false)
		get_prop('EngineRoomDoor').disable(false)


func on_room_transition_finished() -> void:
	if C.player.last_room != 'FirstFloor' and C.player.last_room != 'EngineRoom':
		yield(E.run([
			C.player_walk_to(get_point('Entry')),
			'Player: Well... here we go'
		]), 'completed')
	
	# TODO: Iniciar la cuenta regresiva para la muerte del jugador


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func use_pc() -> void:
	if Globals.state.get('Lobby-PC_POWERED'):
		yield(E.run([
			'Player: Its working now',
			A.play({cue_name = 'sfx_pc_startup',is_in_queue = true})
		]), 'completed')
		pc.show()
	else:
		E.run(['Player: No power'])


func open_engine_room() -> void:
	Globals.set_state('Lobby-ENGINE_ROOM_UNLOCKED', true)
	
	# TODO: Dejo esto aquí por si hace falta meterlo para tener un mejor control
	#		del flujo de esta parte.
#	yield(C.walk_to_clicked(false), 'completed')
#	G.emit_signal('nft_won', Globals.NFTs.ENGINE_ROOM)
#	yield(G, 'nft_shown')
	
	yield(E.run([
		C.walk_to_clicked(),
		E.runnable(
			G,
			'emit_signal',
			['nft_won', Globals.NFTs.ENGINE_ROOM],
			'nft_shown'
		),
		'Player: Woooooooh!',
		'Player: I can go to the engine room',
		I.remove_item('KeyEngineRoom'),
		get_hotspot('EngineRoom').enable(),
		get_prop('EngineRoomDoor').disable()
	]), 'completed')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
