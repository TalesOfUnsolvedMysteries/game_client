tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([]), 'completed')


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
