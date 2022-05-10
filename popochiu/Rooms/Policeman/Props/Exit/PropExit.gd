tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		A.play({
			cue_name = 'sfx_door_open',
			is_in_queue = true
		})
	]), 'completed')
	E.goto_room('SecondFloor')


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		"Player: It looks like that's the way I can get out of here."
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
