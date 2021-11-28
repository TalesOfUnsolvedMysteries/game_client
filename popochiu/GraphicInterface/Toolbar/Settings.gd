extends PanelContainer

var is_active := false

onready var _dflt_pos := rect_position


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	yield(get_tree(), 'idle_frame')
	rect_position.y += rect_size.y


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func appear() -> void:
	if not is_active:
		is_active = true
		
		$Tween.interpolate_property(
			self, 'rect_position:y',
			rect_position.y, _dflt_pos.y,
			0.3, Tween.TRANS_SINE, Tween.EASE_OUT
		)
	else:
		is_active = false
		
		$Tween.interpolate_property(
			self, 'rect_position:y',
			_dflt_pos.y, rect_position.y + rect_size.y,
			0.3, Tween.TRANS_SINE, Tween.EASE_OUT
		)
	$Tween.start()
