extends 'res://popochiu/GraphicInterface/Popups/Common/GIClickable.gd'

signal changed(node)

var value := -1


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	randomize()
	value = randi() % 10
	self.text = str(value)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func _clicked() -> void:
	value = wrapi(value + 1, 0, 10)
	self.text = str(value)
	
	A.play({cue_name = 'sfx_lock_move', is_in_queue = false})
	emit_signal('changed', self)
