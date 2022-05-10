tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'.',
		open_door(),
		'Player: I can see the motherboard of the engine.'
	]), 'completed')
	E.current_room.show_motherboard()


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func open_door(in_queue := true) -> void:
	if in_queue: yield()
	A.play({cue_name='sfx_open_mainboard_box', is_in_queue=false})
	$Sprite.frame = 1
	yield(get_tree(), 'idle_frame')


func close_door(in_queue := true) -> void:
	if in_queue: yield()
	A.play({cue_name='sfx_close_mainboard_box', is_in_queue=false})
	$Sprite.frame = 0
	yield(get_tree(), 'idle_frame')
