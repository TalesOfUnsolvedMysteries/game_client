extends Control

export var description := ''


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('gui_input', self, '_check_click') # Comentar si es un BaseButton
	connect('mouse_entered', self, '_toggle_description', [true])
	connect('mouse_exited', self, '_toggle_description', [false])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	pass


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_click(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.pressed:
#		E.clicked = self
		if e.is_action_pressed('popochiu-interact'):
			Utils.invoke(self, '_interact')
			get_tree().set_input_as_handled()
		elif e.is_action_pressed('popochiu-look'):
			Utils.invoke(self, 'on_look')


func _interact() -> void:
	if not I.active:
		# TODO: ¿Registrar esta acción en el historial?
		on_interact()
	else:
		on_item_used(I.active)


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
