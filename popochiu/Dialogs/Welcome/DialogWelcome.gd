tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	yield(E.run([
		'CoHost: Hi [color=#0a89ff]%s[/color], Welcome to The Bug Adventure Show!'\
		% Globals.bug_name,
		"CoHost: I'm Pacheco. How do you feel?"
	]), 'completed')
	
	# La llamada al método start del padre hace que se muestren las opciones
	.start()


func option_selected(opt: DialogOption) -> void:
	yield(E.run([
		'Player: ' + opt.text,
		'CoHost: That sounds great!'
	]), 'completed')
	D.emit_signal('dialog_finished')
