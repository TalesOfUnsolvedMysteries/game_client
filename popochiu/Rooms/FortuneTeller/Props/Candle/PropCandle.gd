tool
extends Prop

var on := false setget _set_on
export var candle_index = 0

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: %s' % ('PUUUFFFF' if on else 'TA DA!')
	]), 'completed')
	
	self.on = !on


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _set_on(value: bool) -> void:
	on = value
	$AnimatedSprite.play('on' if on else 'off')
	var _config: String = Globals.state.get('RITUAL_configuration')
	_config[candle_index] = '1' if on else '0'
	Globals.set_state('RITUAL_configuration', _config)

