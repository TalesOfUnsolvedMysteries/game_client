tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	yield(E.run([
		"CoHost: We're almost done.",
		"CoHost: I know you may be impatient to get started.",
		"CoHost: Tell us what do you expect?",
	]), 'completed')
	
	# La llamada al método start del padre hace que se muestren las opciones
	.start()


func option_selected(opt: DialogOption) -> void:
	yield(E.run([
		'Player: ' + opt.text,
		'CoHost: Well [color=#0a89ff]%s[/color], we hope that what we have prepared will more than satisfy them.'\
		% Globals.bug_name
	]), 'completed')
	D.emit_signal('dialog_finished')
