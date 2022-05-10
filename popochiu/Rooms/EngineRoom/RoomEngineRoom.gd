tool
extends PopochiuRoom


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	if Engine.editor_hint:
		return
	
	if not Globals.state.get('Lobby-ENGINE_ROOM_UNLOCKED'):
		Globals.set_state('Lobby-ENGINE_ROOM_UNLOCKED', true)
	
	if not Globals.state.get('EngineRoom-SWITCH_BOX_OPENED'):
		$CanvasLayer/Lock.connect(
			'combination_changed',
			get_prop('FuseBox'),
			'check_combination'
		)
	else:
		get_prop('FuseBox').open()
	
	$CanvasLayer/Motherboard.connect('closed', self, '_change_engine_frame')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	.on_room_entered()
	if Globals.state.get('Lobby-PC_POWERED'):
		A.play_music('mx_engine_power_on', false, 0.0, true, 0.3)
	if Globals.state.get('EngineRoom-ELEVATOR_WORKING') and Globals.state.get('ELEVATOR_ENABLED') > 0:
		A.play_music('mx_elevator_working_loop', false, 0.0, true, 0.3)


func on_room_exited() -> void:
	print('on room exited')
	A.stop('mx_engine_power_on', 0, false, true, 0.3)
	A.stop('mx_elevator_working_loop', 0, false, true, 0.3)
	.on_room_exited()


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_lock() -> void:
	$CanvasLayer/Lock.appear()
	A.play({cue_name = 'sfx_lock_enter', is_in_queue = false})


func hide_lock() -> void:
	$CanvasLayer/Lock.disappear()


func show_motherboard() -> void:
	$CanvasLayer/Motherboard.appear()


func turn_on_pc_switch() -> void:
	Globals.set_state('Lobby-PC_POWERED', true)
	get_prop('FuseBox').turn_on_switch()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _change_engine_frame() -> void:
	E.run([
		'.',
		get_prop('Engine').close_door()
	])
