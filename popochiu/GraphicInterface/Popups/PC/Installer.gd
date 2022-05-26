extends Control

var OS setget setOS
onready var _continue_btn: Button = find_node('Continue')
onready var _close_btn: Button = find_node('Close')
onready var _loader_progress: ColorRect = find_node('Loaded')

signal close_requested

var installing = false
var _progress = 0
const TOTAL = 124
export var installation_speed = 5.0
export var installation_key = 'something'

func _ready():
	$Loader.visible = true
	$AnimationPlayer.play('open')
	_continue_btn.connect('pressed', self, '_on_continue')
	
	$BtnClose.connect('pressed', self, 'emit_signal', ['close_requested'])
	_close_btn.connect('pressed', self, 'emit_signal', ['close_requested'])
	
	$Confirm.show()
	$BtnClose.show()
	$Installation.hide()
	_close_btn.hide()
	
	if Globals.state.get(installation_key, false):
		$Confirm/Information.bbcode_text = '[center]This program is already installed[/center]'
		_continue_btn.hide()

func setOS(_OS):
	OS = _OS

func dispose():
	$AnimationPlayer.play('open', -1, -1, true)
	A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')


func _on_continue():
	$Confirm.hide()
	$BtnClose.hide()
	$AnimationPlayer.play('open')
	$Installation.show()
	#A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')
	installing = true

func _on_installed():
	installing = false
	_loader_progress.rect_size.x = TOTAL
	$AnimationPlayer.play('open', -1, 1.5)
	$Installation/Text.bbcode_text = '[center]Elevator 2.0 installed successfully![/center]'
	_close_btn.show()
	#A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')
	Globals.set_state(installation_key, true)

func _process(_delta):
	if !installing: return
	_progress += _delta * installation_speed 
	_loader_progress.rect_size.x = _progress
	if _progress >= TOTAL:
		_on_installed()
