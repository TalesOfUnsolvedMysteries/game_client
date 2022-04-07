extends 'res://popochiu/GraphicInterface/Popups/PC/Icon.gd'

onready var app_name = find_node('Name')
var error = 0

func _ready():
	set_elevator_version(Globals.state.get('PC_ELEVATOR_APP_VERSION'))

func set_elevator_version(version):
	app_name.text = 'Elevator %d.0' % version

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func open_app() -> void:
	var version = Globals.state.get('PC_ELEVATOR_APP_VERSION')
	var elevator_state = Globals.state.get('ELEVATOR_ENABLED')

	if Globals.state.get('Lobby-ELEVATOR_CARD_IN_PC'):
		if (version == 1 and elevator_state > 0) or (version == 2 and elevator_state == 31):
			error = 1
			owner.show_popup('w', 'elevator program is already fixed', self)
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
	if error == 1:
		Globals.set_state('ELEVATOR_CARD_LAST_LOCATION', 'EngineRoom-MOTHERBOARD_WITH_CARD')
		yield(E.run([
			"Player: I'll take the elevator program card.",
			I.add_item('ElevatorCard'),
			A.play({
				cue_name = 'sfx_elevator_card_pick',
				is_in_queue = true
			})
		]), 'completed')
	
