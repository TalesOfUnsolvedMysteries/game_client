tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		E.runnable(room, 'show_notes')
	]), 'completed')


func on_look() -> void:
	yield(E.run(['Player: It is a very well laid bed']), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
