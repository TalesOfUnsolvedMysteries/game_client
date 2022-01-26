extends 'res://popochiu/GraphicInterface/Popups/PCContainer/Icon.gd'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func open_app() -> void:
	if Globals.state.get('Lobby-ELEVATOR_CARD_IN_PC'):
		# TODO: Abrir la aplicación para modificar el comportamiento del ascensor.
		pass
	else:
		# TODO: Mostrar un mensaje de error en el SO indicando que se necesita
		#		la tarjeta del elevador para poder usar la aplicación.
		owner.show_popup('w', 'not elevator card found', self)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func on_popup_closed() -> void:
	E.run(['Player: Looks like I need to put something in the PC in order to open this app.'])
