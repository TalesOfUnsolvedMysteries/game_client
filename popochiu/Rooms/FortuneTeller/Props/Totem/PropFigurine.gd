tool
extends Prop

export(String, 'A', 'B', 'C', 'D', 'E') var totem_symbol = 'A'

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.player_walk_to(room.get_point('figurine_stand')),
		C.face_clicked()
	]), 'completed')
	
	E.current_room.toggle_figurine(self)


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass

func select():
	self.position.y -= 3
	$Anim.play('selected')

func unselect():
	self.position.y += 3
	$Anim.play('RESET')
