tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([C.walk_to_clicked()]), 'completed')
	if Globals.state.get('EngineRoom-MOTHERBOARD_WITH_CARD')\
		and Globals.state.get('ELEVATOR_ENABLED') == 31:
		E.run([
			'Player: I don\'t have to do anything else in that room'
		])
	else:
		E.goto_room('EngineRoom')
		E.run([
			E.wait(0.3),
			A.play({ cue_name = 'sfx_walk_stairs', is_in_queue = true})
		])


func on_look() -> void:
	E.run([
		'Player: Those are the stairs to go to the engine room'
	])


func on_item_used(item: InventoryItem) -> void:
	pass
