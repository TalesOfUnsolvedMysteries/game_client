extends Control
# Hace que el ascensor vaya a diferentes pisos dentro del edificio.
# TODO: ¿Poner un Tween para cuando aparece y desaparece el panel?
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

onready var _buttons: Control = find_node('Buttons')
onready var _dflts := {
	panel_pos = $Panel.rect_position
}
onready var _out_y := get_viewport().get_visible_rect().end.y + 8.0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Overlay.modulate.a = 0.0
	$Panel.rect_position.y = _out_y
	
	# Conectarse a señales de los singleton
	G.connect('elevator_panel_requested', self, '_open')
	
	# Conectarse a señales de los hijos
	$Overlay.connect('pressed', self, '_close')
	for b in _buttons.get_children():
		b.connect('floor_selected', self, '_goto_floor')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _open() -> void:
	for b in _buttons.get_children():
		b.set_pressed_no_signal(false)
	
	show()

	$Tween.interpolate_property(
		$Overlay, 'modulate:a',
		0.0, 1.0,
		0.3, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		$Panel, 'rect_position:y',
		$Panel.rect_position.y, _dflts.panel_pos.y,
		0.5, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	$Tween.start()


func _close() -> void:
	$Tween.interpolate_property(
		$Overlay, 'modulate:a',
		1.0, 0.0,
		0.4, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		$Panel, 'rect_position:y',
		$Panel.rect_position.y, _out_y,
		0.3, Tween.TRANS_BACK, Tween.EASE_IN
	)
	$Tween.start()
	
	if NetworkManager.isPilot():
		rpc_id(1, '_net_close')

	yield($Tween, 'tween_all_completed')
	
	hide()


remote func _net_close():
	if NetworkManager.isServerWithPilot():
		_close()


func _goto_floor(go_to: String) -> void:
	yield(_close(), 'completed')
	
	if go_to != E.current_room.script_name:
		# TODO: Emitir una señal para que se abran las puertas del ascensor.
		E.goto_room(go_to)
	else:
		E.run(["Player: I'm already in this floor..."])
