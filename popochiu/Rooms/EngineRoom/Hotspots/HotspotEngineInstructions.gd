tool
extends Hotspot

export(Array, String, MULTILINE) var pages = []
export var background: Texture = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: This are the instructions for the engine.'
	]), 'completed')
	
	G.show_documents({pages = pages, bg = background})


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass
