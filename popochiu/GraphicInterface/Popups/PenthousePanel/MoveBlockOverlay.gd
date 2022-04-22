extends "res://popochiu/Common/Overlay2D.gd"

signal solved


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Puzzle.connect('solved', self, 'emit_signal', ['solved'])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _appeared() -> void:
	global_position.x = C.player.global_position.x
	$Camera2D.current = true
	
	if get_node_or_null('Puzzle'):
		$Puzzle.show()


func _disappeared() -> void:
	$Camera2D.current = false
	E.main_camera.current = true
	
	if get_node_or_null('Puzzle'):
		$Puzzle.hide()
