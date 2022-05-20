extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	E.run([
		'Player: What is this?'
	])


func on_look() -> void:
	E.run([
		"Player: Symbols I don't understand..."
	])


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MagicGlasses':
		get_parent().show_hidden(true)
	else:
		.on_item_used(item)
