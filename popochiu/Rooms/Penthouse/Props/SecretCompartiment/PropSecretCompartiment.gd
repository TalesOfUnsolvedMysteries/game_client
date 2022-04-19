tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	# TODO: This should show the panel popup, and once successfully solved, call
	#		the _show_interior function.
	yield(E.run([
		C.walk_to_clicked(),
		'Player: What is this for?',
		'...',
		'Player: Ooops!',
		E.runnable(self, '_show_interior', [], 'completed'),
		'Player: Yikes! There is a dead body...'
	]), 'completed')


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass

func _on_reveal():
	$Sprite.region_rect.size.y = 0
	self.show()
	yield(get_tree().create_timer(0.3), 'timeout')
	$Tween.interpolate_property($Sprite, 'region_rect:size:y', 0, 45, 1.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.5)
	$Tween.start()
	yield(E.run([
		E.wait(1.7),
		'Player: Another secret compartiment?',
	]), 'completed')


func _show_interior() -> void:
	# TODO: Use an animation for this
	yield(get_tree().create_timer(1.0), 'timeout')
	$Compartiment.show()
