extends TextureButton

signal floor_selected

export(String, 'Penthouse', 'ThirdFloor', 'SecondFloor', 'FirstFloor') var go_to := ''


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _toggled(button_pressed: bool) -> void:
	if button_pressed:
		yield(get_tree().create_timer(0.3), 'timeout')
		
		emit_signal('floor_selected')
		E.goto_room(go_to)
