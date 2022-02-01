extends TextureButton

signal floor_selected(target)

export(String, 'Penthouse', 'ThirdFloor', 'SecondFloor', 'FirstFloor') var go_to := ''


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _toggled(button_pressed: bool) -> void:
	if button_pressed:
		yield(E.run([
			A.play({
				cue_name = 'sfx_key_press',
				in_queue = true,
				wait_audio_complete = true
			}),
			E.wait(0.1)
		]), 'completed')
		
		emit_signal('floor_selected', go_to)
