tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	#E.goto_room('forest')
	print('oh yeah!')
	#print(get_tree().network_peer.get_connection_status())


func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	pass
