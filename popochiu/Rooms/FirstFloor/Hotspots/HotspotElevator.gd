tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if Globals.state.get('EngineRoom-ELEVATOR_WORKING'):
		yield(E.run([C.walk_to_clicked()]), 'completed')
		G.emit_signal('elevator_panel_requested')
	else:
		E.run([
			C.walk_to_clicked(),
			A.play({
				cue_name = 'sfx_elevator_not_working',
				is_in_queue = true,
				wait_audio_complete = true
			}),
			'Player: It is not working...'
		])


func on_look() -> void:
	E.run([
		'Player: The elevator',
		'Player: Probably gives access to the other floors',
	])


func on_item_used(item: InventoryItem) -> void:
	pass
