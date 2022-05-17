tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	var summoned = Globals.state.get('RITUAL_summoned', [])
	for option in options:
		if summoned.has(option.id):
			option.visible = true
	.start()


func option_selected(opt: DialogOption) -> void:
	if opt.id == 'No':
		yield(E.run([
			'Player: yeah...',
			'Player: it is better to left the deads in peace'
		]), 'completed')
		D.emit_signal('dialog_finished')
	elif opt.id == 'Yes':
		yield(E.run([
			'Player: I\'m freaking scared!',
		]), 'completed')
		D.emit_signal('dialog_finished')
		E.current_room.start_ritual()
	else:
		yield(E.run([
			'Player: what else can the bug from %s could tell me?' % opt.id,
		]), 'completed')
		D.emit_signal('dialog_finished')
		E.current_room.get_node('SecretAdn').get_adn_for(opt.id)
