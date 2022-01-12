tool
extends Prop

export(Array, String, MULTILINE) var pages = []


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: Lets check this notes... because I am a chismoso'
	]), 'completed')
	
	G.show_documents({pages = pages})


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
