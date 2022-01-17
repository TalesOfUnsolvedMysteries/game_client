extends Control

export var description := ''


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('gui_input', self, '_check_click') # Comentar si es un BaseButton
	connect('mouse_entered', self, '_toggle_description', [true])
	connect('mouse_exited', self, '_toggle_description', [false])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _clicked() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_click(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
	and mouse_event.pressed:
		_clicked()
		if NetworkManager.isPilot():
			rpc_id(1, '_net_clicked')


remote func _net_clicked():
	if NetworkManager.isServerWithPilot():
		_clicked()


func _toggle_description(is_mouse_inside: bool) -> void:
	if E.is_frozen: return
	
	if is_mouse_inside:
		if I.active:
			G.show_info('Use %s with %s' % [I.active.description, description])
		else:
			Cursor.set_cursor(Cursor.Type.USE)
			G.show_info(description)
	else:
		Cursor.set_cursor()
		G.show_info()
