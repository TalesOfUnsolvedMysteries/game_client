tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: Poems...',
		'Player: Lets see if I can understand them'
	]), 'completed')
	
	# TODO: Open the popup with the clues about playing a song for each of the
	#		three times of the day (morning, afternoon, night).


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A notebook.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
