tool
extends Hotspot


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	print('on clicked to first floor')
	yield(E.run([
		C.walk_to_clicked()
	]), 'completed')
	
	E.goto_room('FirstFloor')


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass
