extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal changed(node)

sync var value := -1 setget set_value
sync var stylebox_normal: StyleBoxTexture = null
var stylebox_hover: StyleBoxTexture = null

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	value = 0
	stylebox_normal = get_stylebox('normal')
	stylebox_hover = get_stylebox('hover')
	
	if NetworkManager.isServerWithPilot():
		rset_id(NetworkManager.pilot_peer_id, 'value', value)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	var val := wrapi(value + 1, 0, 4)
	
	set_value(val)
	stylebox_normal.region_rect.position.x = val * 42.0
	stylebox_hover.region_rect.position.x = val * 42.0
	
	A.play({cue_name = 'sfx_lock_move', is_in_queue = false})
	emit_signal('changed', self)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func set_value(_value):
	value = _value
