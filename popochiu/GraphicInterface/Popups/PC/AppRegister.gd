extends Panel
# Controla la aplicación para mostrar el registro de habitantes del edificio.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

enum Fields { NAME, ARCANE, DEATH }

const DATA := preload('res://popochiu/Data.gd')

var _current_field := -1
var _selected_option: CheckBox = null
var _info := {} # (!) Esto es nomás para hacer pruebas locales
var OS
var extra = ''
signal close_requested

onready var _current_tab: Control = $TabContainer.get_current_tab_control()
onready var _current_tab_name: String = _current_tab.name setget set_current_tab
onready var _data_container: VBoxContainer = find_node('DataContainer')
onready var _name: Label = find_node('Name')
onready var _btn_name: TextureButton = find_node('RowName').get_node('BtnEdit')
onready var _arcane: Label = find_node('Arcane')
onready var _btn_arcane: TextureButton = find_node('RowArcane').get_node('BtnEdit')
onready var _death: Label = find_node('Death')
onready var _btn_death: TextureButton = find_node('RowDeath').get_node('BtnEdit')
onready var _title: Label = $PopupContainer.find_node('Title')
onready var _options: VBoxContainer = $PopupContainer.find_node('OptionsContainer')
onready var _btn_ok: Button = $PopupContainer.find_node('BtnOk')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$BtnClose.connect('pressed', self, 'emit_signal', ['close_requested'])
	$TabContainer.connect('tab_changed', self, '_update_tab_info')
	_btn_name.connect('pressed', self, '_open_popup', [Fields.NAME])
	_btn_arcane.connect('pressed', self, '_open_popup', [Fields.ARCANE])
	_btn_death.connect('pressed', self, '_open_popup', [Fields.DEATH])
	_btn_ok.connect('pressed', self, '_set_data')
	$PopupContainer/Overlay.connect('pressed', self, '_close_popup')
	
	$PopupContainer.hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _open_popup(type: int) -> void:
	var options := []
	var selected := ''
	var title := 'choose %s'
	
	match type:
		Fields.NAME:
			options = DATA.NAMES
			selected = _name.text
			_title.text = title % 'a name'
		Fields.ARCANE:
			options = DATA.ARCANES
			selected = _arcane.text
			_title.text = title % 'an arcane'
		Fields.DEATH:
			options = DATA.DEATHS
			selected = _death.text
			_title.text = title % 'a cause of death'
	
	for o in options:
		var opt_btn: CheckBox = CheckBox.new()
		_options.add_child(opt_btn)

		opt_btn.text = o
		if selected == o:
			_selected_option = opt_btn
			opt_btn.set_pressed_no_signal(true)
		opt_btn.connect('toggled', self, '_toggle_selection', [opt_btn])
	
	_current_field = type
	$PopupContainer.show()
	
	if is_instance_valid(_selected_option):
		yield(get_tree().create_timer(0.02), 'timeout')
		(_options.get_parent() as ScrollContainer).get_v_scrollbar().value =\
		_selected_option.rect_position.y


func _close_popup() -> void:
	# Reiniciar los valores por defecto para cuando se abra otro Popup
	for cb in _options.get_children():
		cb.queue_free()
	_current_field = -1
	_selected_option = null
	_title.text = ''
	(_options.get_parent() as ScrollContainer).get_v_scrollbar().value = 0.0
	
	$PopupContainer.hide()


func _toggle_selection(button_pressed: bool, button: CheckBox) -> void:
	if is_instance_valid(_selected_option):
		_selected_option.set_pressed_no_signal(false)
	
	_selected_option = button if button_pressed else null


func _set_data() -> void:
	if not _info.has(_current_tab_name):
		_info[_current_tab_name] = {}
	
	match _current_field:
		Fields.NAME:
			# TODO: Mandar esa información al servidor y validar el Secret
			_name.text = _selected_option.text
			_info[_current_tab_name].name = _name.text
		Fields.ARCANE:
			# TODO: Mandar esa información al servidor y validar el Secret
			_arcane.text = _selected_option.text
			_info[_current_tab_name].arcane = _arcane.text
		Fields.DEATH:
			# TODO: Mandar esa información al servidor y validar el Secret
			_death.text = _selected_option.text
			_info[_current_tab_name].death = _death.text
	
	_close_popup()


func _update_tab_info(_tab_index: int) -> void:
	_current_tab.remove_child(_data_container)
	_current_tab = $TabContainer.get_current_tab_control()
	self._current_tab_name = _current_tab.name
	_current_tab.add_child(_data_container)


func set_current_tab(value: String) -> void:
	_current_tab_name = value
	
	_name.text = '????'
	_arcane.text = '????'
	_death.text = '????'
	
	if _info.has(_current_tab_name):
		if _info[_current_tab_name].has('name'):
			_name.text = _info[_current_tab_name].name
		if _info[_current_tab_name].has('arcane'):
			_arcane.text = _info[_current_tab_name].arcane
		if _info[_current_tab_name].has('death'):
			_death.text = _info[_current_tab_name].death

func dispose():
	yield(get_tree(), 'idle_frame')
	#$AnimationPlayer.play('open', -1, -1, true)
	A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	#yield($AnimationPlayer, 'animation_finished')
