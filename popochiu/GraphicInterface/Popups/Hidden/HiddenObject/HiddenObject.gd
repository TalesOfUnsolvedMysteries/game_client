extends Area2D


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
#	connect('mouse_entered', self, '_mouse_entered')
#	connect('mouse_exited', self, '_mouse_exited')
	connect('area_entered', self, '_area_entered')
	connect('area_exited', self, '_area_exited')
	
#	enable()


#func _input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void:
#	var mouse_event: = event as InputEventMouseButton
#	if mouse_event and mouse_event.button_index == BUTTON_LEFT:
#		if mouse_event.pressed:
#			prints('pepino')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func disable() -> void:
	disconnect('input_event', self, '_on_input_event')


func enable() -> void:
	connect('input_event', self, '_on_input_event')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _area_entered(area2d: Area2D) -> void:
	prints('entra', area2d.name)


func _area_exited(area2d: Area2D) -> void:
	prints('sale', area2d.name)


func _on_input_event(_viewport: Node, event: InputEvent, _shape: int):
	var mouse_event: = event as InputEventMouseButton
	if mouse_event and mouse_event.button_index == BUTTON_LEFT:
		if mouse_event.pressed:
			get_tree().set_input_as_handled()
			_clicked()
		else:
			_released()


func _clicked() -> void:
	prints('¡Ay! ¿Qué es esta presión?')


func _released() -> void:
	prints('Ufff')
