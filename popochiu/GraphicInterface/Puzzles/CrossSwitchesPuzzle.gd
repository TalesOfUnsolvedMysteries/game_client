extends Control

var secret: Secret
onready var floor_links: Control = find_node('FloorLinks')
onready var app_title: Label = find_node('Title')
var OS
signal close_requested

func _ready():
	randomize()
	$BtnClose.connect('button_down', self, '_reset')
	
	secret = find_node('Secret1')
	if Globals.state['PC_ELEVATOR_APP_VERSION'] == 2:
		floor_links.get_node('LinksF').show()
		self.unlock_buttons()
		secret = find_node('Secret2')
		var light1 = find_node('Light1')
		light1.modulate = Color('ffffff')

	app_title.text = 'elevator panel v%d.0' % Globals.state['PC_ELEVATOR_APP_VERSION']
	$Save.connect('button_down', self, '_on_save_pressed')
	$Save.disabled = false
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
		for j in range(0, 5):
			floor_list.get_child(4 - j).visible = (int(switch) & int(pow(2, j))) > 0
		i += 1

func on_button_toggled(value, index):
	Utils.invoke(secret, 'toggle_switch', [value, index], !Globals.is_single_test())
	var sfx_audio = 'sfx_pc_app_toggle_on' if value else 'sfx_pc_app_toggle_off'
	A.play({cue_name = sfx_audio, is_in_queue = false})

func _turn_lights_on(pressed):
	for i in range(0, 5):
		var val:int = int(pow(2, i))
		toggle_light(bool(pressed & val), i)


func _reset():
	emit_signal('close_requested')
	for button in $Buttons.get_children():
		button.pressed = false
	_turn_lights_on(0)

func toggle_light(value, index):
	var light = $Lights.get_child(index)
	var color := Color('415d66') if value else Color('bdffca')
	
	if index == 0: # the basement
		light.get_node('Label').set(
			'custom_colors/font_outline_modulate',
			Color('bdffca') if value else Color('415d66')
		)
	
	light.get_node('Label').set(
		'custom_colors/font_color',
		Color('415d66') if value else Color('bdffca')
	)
	
	(light.texture as AtlasTexture).region.position.x = 32 if value else 0

func unlock_buttons():
	$Buttons/ButtonD.disabled = false
	$Buttons/ButtonE.disabled = false
	$Buttons/ButtonF.disabled = false
	$FloorLinks/LinksD.modulate = Color.white
	$FloorLinks/LinksE.modulate = Color.white
	$FloorLinks/LinksF.modulate = Color.white

func _on_save_pressed():
	Utils.invoke(self, '_save_config')

func _save_config():
	$Save.disabled = true
	# displays a popup? saying validating config
	# delay the validation a little more
	print('check config...')
	secret.solve(null)
	
func _check(solved):
	if solved:
		OS.show_popup('w', 'elevator fixed!', self)
		for button in $Buttons.get_children(): button.disabled = true
		Globals.set_state('ELEVATOR_CARD_LAST_LOCATION', 'Lobby-ELEVATOR_CARD_IN_PC')
		E.run([
			I.add_item('ElevatorCard'),
			A.play({
				cue_name = 'sfx_elevator_card_pick',
				is_in_queue = true
			})
		])
	else:
		OS.show_popup('e', 'wrong configuration!', self)
		$Save.disabled = false
		_reset()
	

func on_popup_closed() -> void:
	if !Globals.state.get('Lobby-ELEVATOR_CARD_IN_PC'):
		E.run(['Player: I can update the elevator motherboard now.'])

func dispose():
	yield(get_tree(), 'idle_frame')
	#$AnimationPlayer.play('open', -1, -1, true)
	A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	#yield($AnimationPlayer, 'animation_finished')
