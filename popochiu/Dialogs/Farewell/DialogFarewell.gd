tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	yield(E.run([
		'CoHost: There you have it!',
		'CoHost: A new challenger ready for this challenge!',
		'CoHost: Anything you want to say before you enter the building?',
	]), 'completed')
	
	# La llamada al método start del padre hace que se muestren las opciones
	.start()


func option_selected(opt: DialogOption) -> void:
	yield(E.run([
		'Player: ' + opt.text,
		'CoHost: Great!',
		'...'
	]), 'completed')
	D.emit_signal('dialog_finished')
