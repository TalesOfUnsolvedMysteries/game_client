extends Label

signal changed(num)

var value := randi() % 10


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	text = str(value)
	
	connect('gui_input', self, '_check_open_app')
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _check_open_app(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			value = wrapi(value + 1, 0, 10)
			text = str(value)
			A.play({cue_name = 'sfx_lock_move', is_in_queue = false})
			emit_signal('changed', value)
