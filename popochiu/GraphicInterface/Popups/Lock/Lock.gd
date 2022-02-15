extends PanelContainer

signal combination_changed(combination)

var _combination := '' setget _set_combination


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('gui_input', self, '_check_close')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')
	
	for n in $CenterContainer/Bg.get_children():
		_combination += str(n.value)
		n.connect('changed', self, '_check_combination')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	show()
	yield(get_tree().create_timer(0.1), 'timeout')
	G.show_info(_combination)


func disappear() -> void:
	_close_lock()
	
	if NetworkManager.isPilot():
		rpc_id(1, '_net_close_lock')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()

func _close_lock():
	Cursor.set_cursor()
	G.show_info()
	hide()


remote func _net_close_lock():
	if NetworkManager.isServerWithPilot():
		_close_lock()


func _check_combination(number: Label) -> void:
	self._combination[number.get_index()] = str(number.value)


func _set_combination(value: String) -> void:
	_combination = value
	
	if visible:
		G.show_info(_combination)
	
	emit_signal('combination_changed', _combination)
