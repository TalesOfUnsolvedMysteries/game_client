extends "res://popochiu/Common/Overlay2D.gd"


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _appeared() -> void:
	if get_node_or_null('JigsawPuzzle'):
		C.player.face_left(false)
		A.play({cue_name = 'sfx_puzzle_open', is_in_queue=false})
		$JigsawPuzzle.show()


func _disappeared() -> void:
	if get_node_or_null('JigsawPuzzle'):
		A.play({cue_name = 'sfx_puzzle_open', is_in_queue=false, pitch=-3})
		$JigsawPuzzle.hide()
