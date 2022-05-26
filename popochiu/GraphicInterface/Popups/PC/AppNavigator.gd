extends Control

var OS setget setOS
signal close_requested

func _ready():
	load_app()
	$BtnClose.connect('pressed', self, 'emit_signal', ['close_requested'])

func setOS(_OS):
	OS = _OS
	$Installer.connect('app_opened', OS, '_load_app')

func load_app():
	$Loader.visible = true
	$AnimationPlayer.play('open')

func dispose():
	$AnimationPlayer.play('open', -1, -1, true)
	A.play({cue_name = 'sfx_pc_app_close',is_in_queue = false})
	yield($AnimationPlayer, 'animation_finished')
