extends Panel

onready var tween = get_node('Tween')

func _ready():
	connect('gui_input', self, '_check_close')


func _check_close(e: InputEvent) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT \
		and mouse_event.pressed:
			disappear()


func appear(from_room = true):
	$Group.rect_position.y = 175
	if from_room:
		show()
		tween.interpolate_property($Group, 'rect_position:y', 175, 0, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
		tween.start()
	else:
		$Group.rect_position.y = 0
		show()
		tween.interpolate_property($Group/Puzzle, 'modulate:a', 0, 1, 0.5, Tween.TRANS_LINEAR)
		tween.start()

func disappear():
	tween.interpolate_property($Group, 'rect_position:y', 0, 175, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	yield(tween, 'tween_completed')
	hide()
