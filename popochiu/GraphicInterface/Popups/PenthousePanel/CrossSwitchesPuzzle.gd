extends Control

const LIGHT_TEXTURE: AtlasTexture = preload('styles/LightTexture.tres')

var secret: Secret
onready var floor_links: Control = find_node('FloorLinks')

func _ready():
	randomize()
	secret = find_node('Secret')
	secret.connect('solved', self, '_check')

	var i = 0
	for button in $Buttons.get_children():
		#button.connect('toggled', Utils, 'invoke', [self, 'on_button_toggled', [i]])
		button.connect('toggled', self, 'on_button_toggled', [i])
		if !button.disabled and button.pressed: on_button_toggled(true, i)
		i += 1
	
	for l in $Lights.get_children():
		l.texture = LIGHT_TEXTURE.duplicate()
	
	secret.connect('switch_pressed', self, '_turn_lights_on')
	secret.connect('target_updated', self, '_load_target_config')

	if !NetworkManager.server and !Globals.is_single_test():
		secret.connect('switches_changed', self, '_load_switch_table')
	else:
		_load_switch_table()

# setup for floor list labels
func _load_switch_table():
	var i = 0
	for switch in secret._switches:
		$Buttons.get_child(i).set_lights(switch)
		i += 1
	self._load_target_config(secret.target)

func _load_target_config(target):
	for j in range(0, 9):
		var light = $Lights.get_child(j)
		(light.texture as AtlasTexture).region.position.x =\
		 20 if (target & int(pow(2, j))) > 0 else 0

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
	var texture := light.texture as AtlasTexture
	var offset := 0 if !value else 40
	
	if value\
	 and (texture.region.position.x == 20 or texture.region.position.x == 60):
#		light.modulate = Color.red
		texture.region.position.x = 60
	elif not value and texture.region.position.x == 60:
		texture.region.position.x = 20
	elif texture.region.position.x != 20:
		texture.region.position.x = offset
	
	secret.solve(null)

	
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

	
