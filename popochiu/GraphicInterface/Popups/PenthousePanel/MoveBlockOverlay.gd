extends "res://popochiu/Common/Overlay2D.gd"

signal solved

const hide_y = 175
onready var tween = get_node('Tween')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Puzzle.connect('solved', self, 'emit_signal', ['solved'])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _appeared() -> void:
	global_position.x = C.player.global_position.x
	$Camera2D.current = true
	
	if get_node_or_null('Puzzle'):
		$Puzzle.position.y = hide_y
		$Bg.position.y = hide_y
		tween.interpolate_property($Puzzle, 'position:y', hide_y, 0, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.interpolate_property($Bg, 'position:y', hide_y, 0, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Puzzle.show()
		tween.start()


func _disappeared() -> void:
	$Camera2D.current = false
	E.main_camera.current = true
	if get_node_or_null('Puzzle'):
		$Puzzle.hide()

func _check_click(_v: Node, e: InputEvent, _i: int) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
	and mouse_event.pressed:
		tween.interpolate_property($Puzzle, 'position:y', 0, hide_y, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.interpolate_property($Bg, 'position:y', 0, hide_y, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
		yield(tween, 'tween_completed')
		disappear()

func on_solved():
	tween.interpolate_property($Puzzle, 'modulate:a', 1, 0, 0.5, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, 'tween_completed')

