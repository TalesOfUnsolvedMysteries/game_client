extends 'res://popochiu/GraphicInterface/Popups/PC/Icon.gd'

onready var app_name = find_node('Name')
var error = 0

func _ready():
	app_name.text = 'Elevator %d.0' % Globals.state.get('PC_ELEVATOR_APP_VERSION')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func open_app() -> void:
	var version = Globals.state.get('PC_ELEVATOR_APP_VERSION')
	var elevator_state = Globals.state.get('ELEVATOR_ENABLED')

	if Globals.state.get('Lobby-ELEVATOR_CARD_IN_PC'):
		if (version == 1 and elevator_state > 0) or (version == 2 and elevator_state == 31):
			error = 1
			owner.show_popup('w', 'elevator is already working', self)
		else:
			.open_app()
	else:
		# TODO: Mostrar un mensaje de error en el SO indicando que se necesita
		#		la tarjeta del elevador para poder usar la aplicación.
		error = 0
		owner.show_popup('w', 'not elevator card found', self)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func on_popup_closed() -> void:
	if error == 0:
		E.run(['Player: Looks like I need to put something in the PC in order to open this app.'])

