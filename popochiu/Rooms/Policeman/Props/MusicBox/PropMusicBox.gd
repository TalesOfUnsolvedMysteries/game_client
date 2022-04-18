tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([C.walk_to_clicked()]), 'completed')
	
	room.show_jukebox()


func on_look() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: It is a music box.',
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
