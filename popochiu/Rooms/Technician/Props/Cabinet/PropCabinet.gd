tool
extends Prop

export(Array, String, MULTILINE) var pages = []
export var background: Texture = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.player.face_left(),
		'Player: Lets see what I can find here.',
		A.play({cue_name='sfx_open_mainboard_box', wait_audio_complete=true}),
		'Player: A book with notes.',
	]), 'completed')
	
	G.show_documents({pages = pages, bg = background})
	
	yield(G, 'documents_closed')
	
	E.run([
		'Player: Oooook...',
		'Player: I better leave this where it was.',
		A.play({cue_name='sfx_close_mainboard_box', wait_audio_complete=true})
	])
	


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: Some drawers.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)
