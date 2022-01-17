extends PanelContainer

signal closed

export var battery_empty: Texture = null
export var battery_full: Texture = null

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

onready var _display: Label = find_node('Display')
onready var _reset_bulbs: Sprite = find_node('ResetBulbs')
onready var _battery_slot: TextureRect = find_node('BatterySlot')
onready var _battery: TextureRect = find_node('Battery')
onready var _buttons: Control = find_node('Buttons')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	# Definir estado
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		_battery.texture = battery_full
	else:
		_battery.texture = battery_empty
		_display.text = 'replace battery'
	
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	_battery_slot.connect('battery_put', self, '_put_battery')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_WITHOUT_BATTERY'):
		_battery.hide()
	elif Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		_wait_reset()
	
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


func _wait_reset() -> void:
	_pick_code()
	
	for b in _buttons.get_children():
		(b as TextureButton).connect('pressed', self, '_check_secuence', [b])


func _pick_code() -> void:
	_current_code = Utils.get_random_array_element(codes.keys())
	_display.text = _current_code.to_upper()


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
		_reset_bulbs.frame += 1
		
		yield(E.run([
			A.play({
				cue_name = 'sfx_motherboard_success',
				is_in_queue = true,
				wait_audio_complete = true,
			})
		]), 'completed')
		
		self._matches = 0
		
		if _reset_bulbs.frame == 3:
			_display.text = 'RESET DONE'
			# TODO: Reproducir un sonido para reforzar que ya se hizo la resetiada
			#		de la motherboard.
		else:
			_pick_code()


func _set_matches(value: int) -> void:
	_matches = value
	
	for b in _buttons.get_children():
		(b as TextureButton).pressed = false


func _put_battery() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		_battery.texture = battery_full
		_wait_reset()
	else:
		_battery.texture = battery_empty
	
	_battery.show()
