tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		A.play({
			cue_name = 'sfx_door_open',
			is_in_queue = true
		})
	]), 'completed')
	E.goto_room('Technician')


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass
