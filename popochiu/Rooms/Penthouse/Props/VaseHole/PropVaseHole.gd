tool
extends Prop

signal vase_puzzle_solved

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([]), 'completed')

func set_solved():
	self.show()
	$Vase.show()

func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if item.script_name != 'VaseYellow':
		yield(E.run([
			C.walk_to_clicked(),
			'Player: I don\'t think it is working...'
		]), 'completed')
		return
	yield(E.run([
		C.walk_to_clicked(),
		'Player: let\'s put this Yellow thing here',
		A.play({cue_name='sfx_remove_vase', wait_audio_complete=true}),
		I.remove_item(item.script_name, false)
	]), 'completed')
	$Vase.show()
	emit_signal('vase_puzzle_solved')
	

func on_reveal() -> void:
	$Sprite.region_rect.size.y = 0
	self.show()
	yield(get_tree().create_timer(0.5), 'timeout')
	$Tween.interpolate_property(
		$Sprite, 'region_rect:size:y',
		0, 19,
		1.1, Tween.TRANS_CUBIC, Tween.EASE_IN,
		0.5
	)
	$Tween.start()
	yield(E.run([
		E.wait(0.5),
		A.play({cue_name = 'sfx_remove_vase'}),
		E.wait(1.3),
		'Player: a secret compartiment has been revealed!',
	]), 'completed')

func on_hide() -> void:
	if !visible: return
	$Tween.interpolate_property(
		$Sprite, 'region_rect:size:y',
		19, 0,
		0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()
	yield($Tween, 'tween_completed')
	self.hide()
