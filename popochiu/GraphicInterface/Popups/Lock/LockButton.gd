extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal changed(node)

sync var value := -1 setget set_value


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	randomize()
	value = randi() % 10
	self.text = str(value)
	if NetworkManager.isServerWithPilot():
		rset_id(NetworkManager.pilot_peer_id, 'value', value)

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _clicked() -> void:
	set_value(wrapi(value + 1, 0, 10))
	A.play({cue_name = 'sfx_lock_move', is_in_queue = false})


func set_value(_value):
	value = _value
	self.text = str(value)
	emit_signal('changed', self)


