extends TextureButton

onready var _dflt_pos: Vector2 = $Label.rect_position


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	connect('mouse_entered', Cursor, 'set_cursor', [Cursor.Type.USE])
	connect('mouse_exited', Cursor, 'set_cursor')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _toggled(button_pressed: bool) -> void:
	if button_pressed:
		A.play({
			cue_name = 'sfx_key_press',
			is_in_queue = false
		})
		$Label.rect_position = _dflt_pos + Vector2.DOWN * 2.0
	else:
		A.play({
			cue_name = 'sfx_key_release',
			is_in_queue = false
		})
		$Label.rect_position = _dflt_pos


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func get_value() -> int:
	return $Label.text
