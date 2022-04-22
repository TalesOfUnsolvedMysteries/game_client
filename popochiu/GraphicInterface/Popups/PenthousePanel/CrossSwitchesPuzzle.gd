extends Control

var secret: Secret
onready var floor_links: Control = find_node('FloorLinks')

func _ready():
	randomize()
	secret = find_node('Secret')
	secret.connect('solved', self, '_check')

	var i = 0
	for button in $Buttons.get_children():
		button.connect('toggled', self, 'on_button_toggled', [i])
		if !button.disabled and button.pressed: on_button_toggled(true, i)
		i += 1
	
	secret.connect('switch_pressed', self, '_turn_lights_on')

	if !NetworkManager.server and !Globals.is_single_test():
		secret.connect('switches_changed', self, '_load_switch_table')
	else:
		_load_switch_table()

# setup for floor list labels
func _load_switch_table():
	var i = 0
	for switch in secret._switches:
		var floor_list = floor_links.get_child(i).find_node('FloorsList')
		for j in range(0, 9):
			floor_list.get_child(8 - j).visible = (int(switch) & int(pow(2, j))) > 0
		i += 1
	
	for j in range(0, 9):
		var light = $Lights.get_child(j)
		light.get_node('back').visible = (secret.target & int(pow(2, j))) > 0

func on_button_toggled(value, index):
	Utils.invoke(secret, 'toggle_switch', [value, index], !Globals.is_single_test())
	var sfx_audio = 'sfx_pc_app_toggle_on' if value else 'sfx_pc_app_toggle_off'
	A.play({cue_name = sfx_audio, is_in_queue = false})

func _turn_lights_on(pressed):
	for i in range(0, 9):
		var val:int = int(pow(2, i))
		toggle_light(bool(pressed & val), i)


func _reset():
	for button in $Buttons.get_children():
		button.pressed = false
	_turn_lights_on(0)


func toggle_light(value, index):
	var light = $Lights.get_child(index)
	var color := Color('005280') if !value else Color('25e2cd')
	if value and !light.get_node('back').visible:
		color = Color('0a98ac')
	
	light.get_node('Label').set(
		'custom_colors/font_color',
		color
	)
	
	light.color = color
	
	#(light.texture as AtlasTexture).region.position.x = 32 if value else 0

	
func _check(solved):
	if solved:
		for button in $Buttons.get_children(): button.disabled = true
#		Globals.set_state('ELEVATOR_CARD_LAST_LOCATION', 'Lobby-ELEVATOR_CARD_IN_PC')
#		E.run([
#			I.add_item('ElevatorCard'),
#			A.play({
#				cue_name = 'sfx_elevator_card_pick',
#				is_in_queue = true
#			})
#		])
	else:
		OS.show_popup('e', 'wrong configuration!', self)
		$Save.disabled = false
		_reset()
	
