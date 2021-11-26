tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked()
	]), 'completed')
	
	E.goto_room('Lobby')


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass
