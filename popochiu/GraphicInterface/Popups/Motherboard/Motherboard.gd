extends PanelContainer

signal closed

# NOTA: No sé si esto debería ir en el script de la escena (RoomEngineRoom)
#		para que eventualmente se puedan tomar los códigos del script y no que
#		estén quemados en el texto del inspector (para RoomTechnician/PropNotes).
var codes := {
	welcome = '653',
	car = '081',
	press = '1530',
	desk = '6538',
	mask = '6830',
	back = '615',
	toy = '86531',
	pool = '01568'
}

var _current_code := ''
var _matches := 0 setget _set_matches


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	for b in $CenterContainer/Base/Buttons.get_children():
		(b as TextureButton).connect('pressed', self, '_check_secuence', [b])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	_pick_code()
	
	show()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			_close_motherboard()
			if NetworkManager.isPilot():
				rpc_id(1, '_net_close_motherboard')


func _close_motherboard():
	Cursor.set_cursor()
	G.show_info()
	hide()
	emit_signal('closed')


remote func _net_close_motherboard():
	if NetworkManager.isServerWithPilot():
		_close_motherboard()


func _pick_code() -> void:
	_current_code = Utils.get_random_array_element(codes.keys())
	$CenterContainer/Base/Display.text = _current_code.to_upper()


func _check_secuence(button: TextureButton) -> void:
	if codes[_current_code].find(button.get_value()) > -1:
		_matches += 1
	else:
		# El botón no corresponde al código. Resetear.
		yield(E.run([
			'.',
			A.play({
				cue_name = 'sfx_motherboard_error',
				is_in_queue = true,
				wait_audio_complete = true,
			})
		]), 'completed')
		
		self._matches = 0
		return
	
	if _matches == codes[_current_code].length():
		yield(E.run([
			A.play({
				cue_name = 'sfx_motherboard_success',
				is_in_queue = true,
				wait_audio_complete = true,
			})
		]), 'completed')
		
		self._matches = 0
		_pick_code()


func _set_matches(value: int) -> void:
	_matches = value
	
	for b in $CenterContainer/Base/Buttons.get_children():
		(b as TextureButton).pressed = false
