tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	yield(E.run([
		'Player: The switch that gives power to the lobby is off',
		'Player: Should I turn it on?'
	]), 'completed')
	
	# La llamada al método start del padre hace que se muestren las opciones
	.start()


func option_selected(opt: DialogOption) -> void:
	if opt.id == 'TurnOn':
		yield(E.run([
			'Player: Great!',
			'Player: Now I can use the PC'
		]), 'completed')
		E.current_room.turn_on_pc_switch()
	else: # Exit
		yield(E.run(['Player: Ok. Why not.']), 'completed')
	D.emit_signal('dialog_finished')
