extends InventoryItem

export var empty: Texture = null
export var full: Texture = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
# Cuando se le hace clic en el inventario
func on_interact() -> void:
	.on_interact()


# Lo que pasará cuando se haga clic derecho en el icono del inventario
func on_look() -> void:
	pass


# Lo que pasará cuando se use otro InventoryItem del inventario sobre este
func on_item_used(_item: InventoryItem) -> void:
	pass


func added_to_inventory() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		$Icon.texture = full
		description = 'Motherboard battery charged'
	else:
		$Icon.texture = empty
		description = 'Motherboard battery empty'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func is_full() -> bool:
	return $Icon.texture == full
