extends TextureButton

signal floor_selected(target)

export(String, 'Penthouse', 'ThirdFloor', 'SecondFloor', 'FirstFloor') var go_to := 'Penthouse'

var floor_code = {
	'Penthouse': 16,
	'ThirdFloor': 8,
	'SecondFloor': 4,
	'FirstFloor': 2
}

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _toggled(button_pressed: bool) -> void:
	# check if the floor is enabled
	var enabled = bool(Globals.state['ELEVATOR_ENABLED'] & floor_code[go_to])
	if button_pressed and !enabled:
		print('floor not enabled')
		return

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
