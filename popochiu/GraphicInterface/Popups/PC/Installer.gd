extends Control

var OS setget setOS
onready var _loader_progress: ColorRect = find_node('Loaded')

signal close_requested

var installing = false
var _progress = 0
var _verification_steps = 0
const TOTAL = 124
export var installation_speed = 5.0
export var installation_key = 'something'

func _ready():
	$Loader.visible = true
	$AnimationPlayer.play('open')
	$Confirm/Continue.connect('pressed', self, '_show_verification')
	$Verification/Continue.connect('pressed', self, '_show_verification2')
	$Verification2/Continue.connect('pressed', self, '_show_verification3')
	$Failed/Close.connect('pressed', self, 'emit_signal', ['close_requested'])
	$BtnClose.connect('pressed', self, 'emit_signal', ['close_requested'])
	$Installation/Close.connect('pressed', self, 'emit_signal', ['close_requested'])
	
	$Confirm.show()
	$BtnClose.show()
	$Verification.hide()
	$Verification2.hide()
	$Verification3.hide()
	$Installation.hide()
	$Failed.hide()
	$MazeGame.connect('game_over', self, '_verification_failed')
	$MazeGame.connect('level_completed', self, '_check_verification_progress')
	
	if Globals.state.get(installation_key, false):
		$Confirm/Information.bbcode_text = '[center]This program is already installed[/center]'
		$Confirm/Continue.hide()

func setOS(_OS):
	OS = _OS

func dispose():
	$AnimationPlayer.play('open', -1, -1, true)
	A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')


func _show_verification():
	$AnimationPlayer.play('open')
	$Confirm.hide()
	$BtnClose.hide()
	$Verification.show()

func _show_verification2():
	$AnimationPlayer.play('open')
	$Verification.hide()
	$Verification2.show()

func _show_verification3():
	$AnimationPlayer.play('open')
	$Verification2.hide()
	$Verification3.show()
	$MazeGame.new_game(3, ['001', '002', '003', '004'])

func _show_install():
	$Installation/Close.hide()
	$AnimationPlayer.play('open')
	$MazeGame.close_game()
	$Verification3.hide()
	$Installation.show()
	#A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')
	installing = true

func _on_installed():
	installing = false
	_loader_progress.rect_size.x = TOTAL
	$Installation/Progress.hide()
	$AnimationPlayer.play('open', -1, 1.5)
	$Installation/Text.bbcode_text = '[center]Elevator 2.0 installed successfully![/center]'
	$Installation/Close.show()
	#A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')
	Globals.set_state(installation_key, true)

func _process(_delta):
	if !installing: return
	_progress += _delta * installation_speed 
	_loader_progress.rect_size.x = _progress
	if _progress >= TOTAL:
		_on_installed()

func _verification_failed():
	$AnimationPlayer.play('open')
	$MazeGame.close_game()
	$Verification3.hide()
	$Failed.show()

func _check_verification_progress():
	_verification_steps += 1
	if _verification_steps >= 3:
		print('verification succeded!')
		_show_install()
