extends PanelContainer

var _key_config := '' setget _set_key_config


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	hide()
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	for bitting in $CenterContainer/Bg.get_children():
		if bitting is Button:
			bitting.connect('changed', self, '_save_config')
	
	G.connect('master_key_opened', self, 'appear')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	_set_key_config(Globals.state['MasterKey-CONFIG'])

	show()
	yield(get_tree().create_timer(0.1), 'timeout')
	G.show_info(_key_config)


func disappear() -> void:
	Utils.invoke(self, '_close_key')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░

func _save_config(bitting: Button) -> void:
	print(self._key_config)
	Globals.set_state('MasterKey-CONFIG', self._key_config)


func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()


func _close_key():
	Cursor.set_cursor()
	G.show_info()
	hide()


func _set_key_config(value: String) -> void:
	_key_config = value
	for bitting in $CenterContainer/Bg.get_children():
		if bitting is Button:
			bitting.value = int(_key_config[bitting.get_index() - 1])
	if visible:
		G.show_info(_key_config)
