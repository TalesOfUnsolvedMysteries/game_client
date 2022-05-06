tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked()
	]), 'completed')
	E.goto_room('FirstFloor')
	E.run([
		E.wait(0.3),
		A.play({ cue_name = 'sfx_walk_stairs', is_in_queue = true})
	])


func on_look() -> void:
	E.run([
		'Player: Those are the stairs to go up to the first floor'
	])


func on_item_used(item: InventoryItem) -> void:
	pass
