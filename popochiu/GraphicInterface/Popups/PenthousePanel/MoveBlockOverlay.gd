extends "res://popochiu/Common/Overlay2D.gd"


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _appeared() -> void:
#	global_position.x = C.player.global_position.x
	$Camera2D.current = true
	
#	for b in $Puzzle/Blocks.get_children():
#		b.global_position.x += C.player.global_position.x
	
	if get_node_or_null('Puzzle'):
		$Puzzle.show()


func _disappeared() -> void:
	$Camera2D.current = false
	E.main_camera.current = true
	
	if get_node_or_null('Puzzle'):
		$Puzzle.hide()
