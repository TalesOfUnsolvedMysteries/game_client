tool
extends PopochiuRoom


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
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
	pass


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_lock() -> void:
	$CanvasLayer/Lock.appear()
	A.play({cue_name = 'sfx_lock_enter', is_in_queue = false})


func hide_lock() -> void:
	$CanvasLayer/Lock.disappear()


func show_motherboard() -> void:
	$CanvasLayer/Motherboard.show()


func turn_on_pc_switch() -> void:
	Globals.set_state('Lobby-PC_POWERED', true)
	get_prop('FuseBox').turn_on_switch()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _change_engine_frame() -> void:
	E.run([
		'.',
		get_prop('Engine').close_door()
	])
