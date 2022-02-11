tool
extends PopochiuRoom


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	match C.player.last_room:
		'Writer':
			C.player.position = get_hotspot('Door301').walk_point
			A.play({cue_name = 'sfx_door_close',is_in_queue = false})
		'FortuneTeller':
			C.player.position = get_hotspot('Door302').walk_point
			A.play({cue_name = 'sfx_door_close',is_in_queue = false})
		'FirstFloor', 'SecondFloor', 'Penthouse':
			C.player.position = get_hotspot('Elevator').walk_point
			A.play({cue_name = 'sfx_elevator_beep',is_in_queue = false})


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
