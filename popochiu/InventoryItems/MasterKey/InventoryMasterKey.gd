extends InventoryItem


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
# Cuando se le hace clic en el inventario
func on_interact() -> void:
	A.play({
		cue_name = 'sfx_masterkey_pickup',
		is_in_queue = false
	})
	I.set_active_item(self, false)


# Lo que pasará cuando se haga clic derecho en el icono del inventario
func on_look() -> void:
	A.play({
		cue_name = 'sfx_masterkey_pickup',
		is_in_queue = false
	})
	G.show_master_key()


# Lo que pasará cuando se use otro InventoryItem del inventario sobre este
func on_item_used(_item: InventoryItem) -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _get_description() -> String:
	if I.active == self:
		return description
	return 'Master key\n(right click to modify)'
