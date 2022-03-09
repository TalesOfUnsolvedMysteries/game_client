extends Control

export var _switches = [10, 7, 12, 21, 29, 9]
export var generated = false
var pressed = 0
export var target_number = 31

func _ready():
	randomize()
	var i = 0
	for button in $Buttons.get_children():
		button.connect('toggled', self, 'on_button_toggled', [i])
		if !button.disabled and button.pressed: on_button_toggled(true, i)
		i += 1
	$Unlock.connect('button_down', self, 'unlock_buttons')
	if generated:
		generate_target_number()
		$Generate.connect('button_down', self, 'generate_target_number')

func on_button_toggled(value, index):
	pressed = pressed ^ _switches[index]
	for i in range(0, $Lights.get_child_count()):
		var val:int = int(pow(2, i))
		toggle_light(pressed & val, i)
	if pressed == target_number: $Success.show()

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

func generate_target_number():
	print('---')
	$Success.hide()
	var total = 3 + randi() % 2
	var sorted = _switches.duplicate()
	sorted.shuffle()
	target_number = 0
	for i in range(0, total):
		print (sorted[i])
		target_number = target_number ^ sorted[i]
	
	var text:String = ''
	var numbers = [9,8,7,6,5,4,3,2,1,0]
	for i in range(0, $Lights.get_child_count()):
		var val:int = int(pow(2, i))
		if (target_number & val): text = '%d%s' % [numbers[i], text]
	$TargetCode.text = text


