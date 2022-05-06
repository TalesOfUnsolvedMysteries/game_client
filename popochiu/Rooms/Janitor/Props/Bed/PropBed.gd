tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		A.play({cue_name = 'sfx_paper', pitch=2}),
		E.runnable(room, 'show_notes')
	]), 'completed')


func on_look() -> void:
	yield(E.run(['Player: It is a very well laid bed']), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
