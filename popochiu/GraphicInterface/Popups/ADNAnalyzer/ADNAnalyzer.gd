extends PanelContainer

signal closed(state)

var _state := '' setget set_state
var _adn := ''
var _workin := false

const STATES := {
	no_picker = 'insert picker',
	no_sample = 'no sample',
	analysing = 'analysing sample',
	showing_results = 'showing results',
}

onready var frame: TextureRect = find_node('Frame')
onready var os_name: TextureRect = find_node('OSName')
onready var os_logo: TextureRect = find_node('OSLogo')
onready var progress: TextureProgress = find_node('AnalysisProgress')
onready var os_message: Label = find_node('OSMessage')
onready var results_screen: TextureRect = find_node('ResultsScreen')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
#	$AnimationPlayer.play('RESET')
	_set_default()
	
	$Tween.connect('tween_all_completed', self, '_show_results')
	
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear(adn_sample: String) -> void:
	show()
#	A.stop('mx_main', 0, false, true, 2.0)
#	$AnimationPlayer.play('ShowList')
	
	_workin = true
	
	yield(get_tree().create_timer(1.0), 'timeout')
	os_logo.self_modulate.a = 1.0
	yield(get_tree().create_timer(1.0), 'timeout')
	os_name.self_modulate.a = 1.0
	yield(get_tree().create_timer(1.0), 'timeout')
	frame.self_modulate.a = 1.0
	os_message.self_modulate.a = 1.0
	yield(get_tree().create_timer(1.0), 'timeout')
	
	# Definir el estado del S.O.
	if adn_sample:
		_adn = adn_sample
		self._state = STATES.analysing
		progress.self_modulate.a = 1.0
		
		$Tween.interpolate_property(
			progress, 'value',
			null, 100.0,
			3.0, Tween.TRANS_LINEAR, Tween.EASE_IN,
			0.5
		)
		$Tween.start()
	else:
		if I.is_item_in_inventory('ADNpicker'):
			self._state = STATES.no_picker
		else:
			self._state = STATES.no_sample
		
		_workin = false


func disappear() -> void:
	if _workin: return
	
	Utils.invoke(self, '_close')
#	A.play_music('mx_main', false, false)


func set_state(value: String) -> void:
	_state = value
	os_message.text = _state


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()


func _close():
	emit_signal('closed', _state)
	Cursor.set_cursor()
	G.show_info()
	hide()
	_set_default()


func _show_results() -> void:
	Globals.set_state('ADN_picker_content', '')
	
	progress.self_modulate.a = 0.0
	os_logo.self_modulate.a = 0.0
	os_name.self_modulate.a = 0.0
	self._state = STATES.showing_results
	
	results_screen.appear(SecretsKeeper.get(_adn))
	
	yield(results_screen, 'parts_shown')
	
	os_message.text = 'adn: ' + SecretsKeeper.get(_adn)
	
	_workin = false


func _set_default() -> void:
	frame.self_modulate.a = 0.0
	os_name.self_modulate.a = 0.0
	os_logo.self_modulate.a = 0.0
	progress.self_modulate.a = 0.0
	progress.value = 0.0
	os_message.text = 'welcome'
	results_screen.modulate.a = 0.0
