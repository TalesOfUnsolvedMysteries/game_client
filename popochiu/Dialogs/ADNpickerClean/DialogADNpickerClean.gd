tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	yield(E.run([
		'Player: Should I throw away the sample?'
	]), 'completed')
	.start()


func option_selected(opt: DialogOption) -> void:
	if opt.id == 'Yes':
		yield(E.run([
			'Player: Ok, just throw it here...',
		]), 'completed')
		var adn_picker = I._get_item_instance('ADNpicker')
		if adn_picker:
			adn_picker.clean_sample()
	else: # No
		yield(E.run(['Player: Ok. Let\'s keep it.']), 'completed')
	D.emit_signal('dialog_finished')
