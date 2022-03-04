extends PanelContainer
# Controla lo que pasa con la placa base del motor para el ascensor.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

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
var _available_codes := []

onready var _display: Label = find_node('Display')
onready var _reset_bulbs: Sprite = find_node('ResetBulbs')
onready var _card_slot: TextureRect = find_node('CardSlot')
onready var _card: TextureRect = find_node('Card')
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
	
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	_card_slot.connect('card_put', self, '_put_elevator_card')
	_card.connect('removed', self, '_check_display_message')
	_battery_slot.connect('battery_put', self, '_put_battery')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_WITHOUT_BATTERY'):
		_battery.hide()
	elif Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		if Globals.state.get('EngineRoom-MOTHERBOARD_RESET'):
			_reset_bulbs.frame = 3
		else:
			_wait_reset()
	
	if Globals.state.get('EngineRoom-MOTHERBOARD_WITH_CARD'):
		_card.show()
	else:
		_card.hide()
	
	_check_display_message()
	
	show()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			Utils.invoke(self, '_close_motherboard')


func _close_motherboard():
	Cursor.set_cursor()
	G.show_info()
	hide()
	emit_signal('closed')


# Hace que inicie el ingreso de códigos en secuencia para resetear la motherboard.
func _wait_reset() -> void:
	_available_codes = codes.keys()
	
	_pick_code()
	
	for b in _buttons.get_children():
		(b as TextureButton).connect('pressed', self, '_check_secuence', [b])


func _pick_code() -> void:
	randomize()
	_available_codes.shuffle()
	
	_current_code = _available_codes.pop_front()
	_display.text = _current_code.to_upper()


func _check_secuence(button: TextureButton) -> void:
	if codes[_current_code].find(button.get_value()) > -1:
		_matches += 1
	else:
		# El botón no corresponde al código -> Resetear.
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
		self._matches = 0
		
		if _reset_bulbs.frame == 3:
			# Se resetió la motherboard
			Globals.set_state('EngineRoom-MOTHERBOARD_RESET', true)
			
			_display.text = 'RESET DONE'
			_current_code = ''
			
			for b in _buttons.get_children():
				(b as TextureButton).disconnect('pressed', self, '_check_secuence')
			
			yield(E.run([
				A.play({
					cue_name = 'sfx_motherboard_reset',
					is_in_queue = true,
					wait_audio_complete = true
				}),
				'Player: Looks like it is ready to read the card with the program.',
				'Player: Or at least that whats the instructions said.'
			]), 'completed')
			
			_check_display_message()
		else:
			yield(E.run([
				A.play({
					cue_name = 'sfx_motherboard_success',
					is_in_queue = true,
					wait_audio_complete = true,
				})
			]), 'completed')
			
			_pick_code()


func _put_battery() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		_battery.texture = battery_full
		
		Globals.set_state('EngineRoom-MOTHERBOARD_WITHOUT_BATTERY', false)
		_wait_reset()
	else:
		_battery.texture = battery_empty
	
	_battery.show()


func _set_matches(value: int) -> void:
	_matches = value
	
	yield(get_tree().create_timer(0.3), 'timeout')
	
	for b in _buttons.get_children():
		(b as TextureButton).pressed = false


func _put_elevator_card() -> void:
	Globals.set_state('EngineRoom-MOTHERBOARD_WITH_CARD', true)
	_card.show()
	
	if Globals.state.get('EngineRoom-MOTHERBOARD_RESET'):
		Globals.set_state('EngineRoom-ELEVATOR_WORKING', true)
	
	_check_display_message()


func _check_display_message() -> void:
	if not Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		_display.text = 'replace battery'
	
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL') \
	and Globals.state.get('EngineRoom-MOTHERBOARD_RESET'):
		_display.text = 'insert card'
		
		if Globals.state.get('EngineRoom-MOTHERBOARD_WITH_CARD'):
			_display.text = 'elevator working'
