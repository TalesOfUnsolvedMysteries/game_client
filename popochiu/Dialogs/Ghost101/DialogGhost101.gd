tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	yield(E.run([
		'Bug101: Quien osa perturbar mi tranquilidad?',
		'Player: Do you speak english?',
		'Bug101: otro gringo...',
		'Bug101: What do you want?',
	]), 'completed')
	
	# La llamada al método start del padre hace que se muestren las opciones
	.start()


func option_selected(opt: DialogOption) -> void:
	if opt.id == 'Opt1':
		yield(E.run([
			'Player: Who...',
			'Player: Who are you?',
			'Bug101: are you blind?',
			'Bug101: I\'m a    [shake rate=25 level=20]G H O S T[/shake]',
			'Player: How scary!'
		]), 'completed')
	if opt.id == 'Opt2':
		yield(E.run([
			'Player: So there is life after death...',
			'Player: How the after life looks like?',
			'Bug101: Did you watch Beetlejuice?',
			'Player: Isn\'t it an old movie about beetles?',
			'Bug101: What are you talking about?',
			'Bug101: ...',
			'Bug101: nevermind...',
			'Bug101: I can\'t rest in peace until\nI solve something here first',
			'Bug101: Are you going to help me?'
		]), 'completed')
	if opt.id == 'Opt3':
		yield(E.run([
			'Player: Were you living in the room 101?',
			'Bug101: I slept there...',
			'Bug101: but it wasn\'t my property.'
		]), 'completed')
	D.emit_signal('dialog_finished')
