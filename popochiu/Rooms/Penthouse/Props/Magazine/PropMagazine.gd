tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: What is this?',
		'Player: A puzzles magazine?',
		'...',
		'Player: What a geek!',
		'Player: Ey! There is a marker in one page'
	]), 'completed')
	
	room.show_magazine()


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
