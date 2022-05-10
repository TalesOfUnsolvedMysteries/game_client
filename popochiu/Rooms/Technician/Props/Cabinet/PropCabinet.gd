tool
extends Prop

export(Array, String, MULTILINE) var pages = []
export var background: Texture = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		"'Player: Lets see what I can find here.'",
		'...',
		'Player: A book with notes.'
	]), 'completed')
	
	G.show_documents({pages = pages, bg = background})


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: Looks like a file cabinet.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
