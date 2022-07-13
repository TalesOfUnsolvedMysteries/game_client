tool
extends Prop

export var normal: Texture
export var hidden: Texture
export var painting_key: String = 'LINK_PUZZLE_KEY_PENTHOUSE'

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: This thing has A LOT of symbols compared with the others.'
	]), 'completed')
	
	room.painting.display_paint(normal, hidden, painting_key)


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: It has symbols that I don´t understand.',
		'Player: And the only one without a notch.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MagicGlasses':
		yield(C.walk_to_clicked(false), 'completed')
		room.painting.display_paint(normal, hidden, painting_key)
		I.set_active_item(null, false)
	else:
		.on_item_used(item)
