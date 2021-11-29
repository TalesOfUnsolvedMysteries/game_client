tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	yield(E.run([
		'CoHost: Finally, what do your parents think about this?',
	]), 'completed')
	
	# La llamada al método start del padre hace que se muestren las opciones
	.start()


func option_selected(opt: DialogOption) -> void:
	yield(E.run([
		'Player: ' + opt.text,
		'CoHost: Lovely',
		'....',
		'CoHost: Simply, lovely.',
		'...'
	]), 'completed')
	D.emit_signal('dialog_finished')
