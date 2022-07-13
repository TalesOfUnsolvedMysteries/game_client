tool
extends PopochiuRoom

onready var pc: PanelContainer = $CanvasLayer/PC
onready var painting: Sprite = $PaintingOverlay2D


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
			A.play({cue_name = 'sfx_pc_startup'})
		]), 'completed')
		pc.show()
	else:
		E.run([
			A.play({cue_name = 'sfx_pc_no_power'}),
			'Player: No power'
		])


func open_engine_room() -> void:
	Globals.set_state('Lobby-ENGINE_ROOM_UNLOCKED', true)
		
	yield(E.run([
		C.walk_to_clicked(),
		A.play({cue_name = 'sfx_engine_room_unlocked', wait_audio_complete = true}),
		E.runnable(
			G,
			'emit_signal',
			['nft_won', Globals.NFTs.ENGINE_ROOM],
			'nft_shown'
		),
		'Player: Woooooooh!',
		'Player: I can go to the engine room',
		A.play({cue_name = 'sfx_engine_room_door_opening', wait_audio_complete = true, fade = true}),
		I.remove_item('KeyEngineRoom'),
		get_hotspot('EngineRoom').enable(),
		get_prop('EngineRoomDoor').disable()
	]), 'completed')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
