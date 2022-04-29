extends Sprite

signal hidden


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Area2D.connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	$Area2D.connect('mouse_exited', Cursor, 'set_cursor')
	$Area2D.connect('input_event', self, '_check_click')
	
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _appeared() -> void:
	pass


func _disappeared() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func appear() -> void:
	E.is_frozen = true
	$Area2D.input_pickable = true
	
	show()
	_appeared()


func disappear() -> void:
	E.is_frozen = false
	$Area2D.input_pickable = false
	
	hide()
	_disappeared()
	
	Utils.invoke(self, 'disappear', [], true)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_click(_v: Node, e: InputEvent, _i: int) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
	and mouse_event.pressed:
		# Esto hace que los bloqueadores de clic puedan actuar antes de que el
		# nodo intente ocultarse -----------------------------------------------
		yield(get_tree(), 'idle_frame')
		if get_tree().is_input_handled(): return
		# ----------------------------------------------------------------------
		
		disappear()
