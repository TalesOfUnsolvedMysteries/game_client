tool
extends PopochiuRoom


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	match C.player.last_room:
		'Policeman':
			C.player.position = get_hotspot('Door201').walk_point
			A.play({cue_name = 'sfx_door_close',is_in_queue = false})
		'Doctor':
			C.player.position = get_hotspot('Door202').walk_point
			A.play({cue_name = 'sfx_door_close',is_in_queue = false})
		'FirstFloor', 'ThirdFloor', 'Penthouse':
			C.player.position = get_hotspot('Elevator').walk_point
			A.play({cue_name = 'sfx_elevator_beep',is_in_queue = false})


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
