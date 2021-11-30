extends "res://popochiu/Common/Overlay2D.gd"


func _appeared() -> void:
	$JigsawPuzzle.show()


func _disappeared() -> void:
	$JigsawPuzzle.hide()
