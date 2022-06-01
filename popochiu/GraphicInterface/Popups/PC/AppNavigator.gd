extends Control

var OS setget setOS
var extra = ''
var _usb_1 = false
var _usb_2 = false
signal close_requested

onready var _elevator = get_node('InstallerElevator')
onready var _registry = get_node('InstallerRegistry')
onready var _readme1 = get_node('Readme')
onready var _readme2 = get_node('Readme2')

func _ready():
	load_app()
	$BtnClose.connect('pressed', self, 'emit_signal', ['close_requested'])


func setOS(_OS):
	OS = _OS
	_elevator.connect('app_opened', OS, '_load_app')
	_registry.connect('app_opened', OS, '_load_app')
	_usb_1 = Globals.state.get('Lobby-USB_IN_PC', false)
	_usb_2 = Globals.state.get('LOBBY-USB2_IN_PC', false)
	if _usb_1 and extra == '1':
		_elevator.show()
		_registry.hide()
		_readme1.show()
		_readme2.hide()
	if _usb_2 and extra == '2':
		_elevator.hide()
		_registry.show()
		_readme1.hide()
		_readme2.show()


func load_app():
	$Loader.visible = true
	$AnimationPlayer.play('open')


func dispose():
	$AnimationPlayer.play('open', -1, -1, true)
	A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')

