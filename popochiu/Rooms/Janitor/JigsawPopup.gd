extends "res://popochiu/Common/Overlay2D.gd"


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _appeared() -> void:
	if get_node_or_null('JigsawPuzzle'):
		$JigsawPuzzle.show()


func _disappeared() -> void:
	if get_node_or_null('JigsawPuzzle'):
		$JigsawPuzzle.hide()
