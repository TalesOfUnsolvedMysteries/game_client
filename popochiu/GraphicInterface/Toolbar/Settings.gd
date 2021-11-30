extends PanelContainer

var is_active := false

onready var _dflt_pos := rect_position


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	modulate.a = 0.0
	connect('visibility_changed', self, '_ultra_hide')
	
	yield(get_tree(), 'idle_frame')
	rect_position.y = rect_position.y + rect_size.y


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func appear() -> void:
	modulate.a = 1.0
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


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _ultra_hide() -> void:
	modulate.a = 0.0
	yield(get_tree(), 'idle_frame')
	
	is_active = false
	rect_position.y = rect_position.y + rect_size.y
