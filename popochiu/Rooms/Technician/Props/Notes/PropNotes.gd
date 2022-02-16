tool
extends Prop

export(Array, String, MULTILINE) var pages = []
export var background: Texture = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: Lets check this notes... because I am a chismoso.'
	]), 'completed')
	
	G.show_documents({pages = pages, bg = background})


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass
