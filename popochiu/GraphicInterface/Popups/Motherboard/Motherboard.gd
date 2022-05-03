extends PanelContainer
# Controla lo que pasa con la placa base del motor para el ascensor.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

signal closed

export var battery_empty: Texture = null
export var battery_full: Texture = null

# NOTA: No sé si esto debería ir en el script de la escena (RoomEngineRoom)
#		para que eventualmente se puedan tomar los códigos del script y no que
#		estén quemados en el texto del inspector (para RoomTechnician/PropNotes).

onready var _display: Label = find_node('Display')
onready var _reset_bulbs: Sprite = find_node('ResetBulbs')
onready var _card_slot: TextureRect = find_node('CardSlot')
onready var _card: TextureRect = find_node('Card')
onready var _battery_slot: TextureRect = find_node('BatterySlot')
onready var _battery: TextureRect = find_node('Battery')
onready var _buttons: Control = find_node('Buttons')
onready var _secret: Secret = find_node('Secret')

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
	
	I.connect('item_discarded', self, '_on_item_discarded')

	_secret.connect('valid_code_entered', self, '_on_valid_code_entered')
	_secret.connect('current_code_changed', self, '_on_current_code_changed')
	G.connect('nft_shown', self, '_on_secret_solved')
	
	for b in _buttons.get_children():
		(b as TextureButton).connect('pressed', self, '_on_button_pressed', [b])

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	if !Globals.state.get('EngineRoom-MOTHERBOARD_WITH_BATTERY'):
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
	_secret.reset_codes()
	_pick_code()

func _pick_code() -> void:
	_display.text = _secret._current_code.to_upper()

func _on_current_code_changed(_current_code) -> void:
	_display.text = _current_code.to_upper()

func _on_button_pressed(button: TextureButton) -> void:
	Utils.invoke(self, '_check_secuence', [button.get_value()])

func _check_secuence(value) -> void:
	_secret.check_button(value)

func _on_secret_solved():
	if not Globals.state.get('EngineRoom-MOTHERBOARD_RESET'):
		return
	yield(_reset_buttons(), 'completed')
	_reset_bulbs.frame += 1
	# Se resetió la motherboard
	_display.text = 'RESET DONE'
	
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

func _on_valid_code_entered(valid):
	if not valid:
		# El botón no corresponde al código -> Resetear.
		yield(E.run([
			'.',
			A.play({
				cue_name = 'sfx_motherboard_error',
				is_in_queue = true,
				wait_audio_complete = true,
			})
		]), 'completed')
	else:
		_reset_bulbs.frame += 1
		yield(E.run([
			A.play({
				cue_name = 'sfx_motherboard_success',
				is_in_queue = true,
				wait_audio_complete = true,
			})
		]), 'completed')
	yield(_reset_buttons(), 'completed')
	_pick_code()


func _put_battery() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		_battery.texture = battery_full
		
		Globals.set_state('EngineRoom-MOTHERBOARD_WITH_BATTERY', true)
		
		if !Globals.state.get('EngineRoom-MOTHERBOARD_WITH_CARD'):
			_wait_reset()
		else:
			_check_display_message()
	else:
		_battery.texture = battery_empty
	
	_battery.show()

func _on_item_discarded(item: InventoryItem):
	if item.script_name == 'MotherboardBattery':
		if Globals.state.get('BATTERY_LAST_LOCATION') == 'EngineRoom-MOTHERBOARD_WITH_BATTERY':
			_battery.show()


func _reset_buttons() -> void:

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
		return
	
	var elevator_level = Globals.state.get('ELEVATOR_ENABLED')

	if Globals.state.get('EngineRoom-MOTHERBOARD_WITH_BATTERY'):
		if Globals.state.get('EngineRoom-MOTHERBOARD_RESET'):
			_display.text = 'insert card'
			if Globals.state.get('EngineRoom-MOTHERBOARD_WITH_CARD'):
				if elevator_level > 0:
					_display.text = 'elevator working'
					if elevator_level == 15:
						yield(E.run([
							'Player: Great! I can use the elevator now!',
						]), 'completed')
					if elevator_level == 31:
						yield(E.run([
							'Player: wooo!!',
							'Player: The elevator is fully operational.',
							'Player: I don\'t need to touch this anymore.',
						]), 'completed')
				else:
					_display.text = 'program outdated'
					yield(E.run([
						'Player: I need to update the elevator card program.',
					]), 'completed')
		else:
			if Globals.state.get('EngineRoom-MOTHERBOARD_WITH_CARD'):
				_display.text = 'remove card'
			else:
				_wait_reset()
	else:
		_display.text = 'insert battery'
