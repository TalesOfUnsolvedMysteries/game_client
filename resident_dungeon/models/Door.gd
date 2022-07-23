extends Resource


class_name DungeonDoor

var key: String
var position := Vector2(0.0, 0.0)
var vertical := false


func _init(_key: String, _position: Vector2, _vertical: bool):
	key = _key
	position = _position
	vertical = _vertical


static func get_key_for(a, b):
	if b < a:
		var t = a
		a = b
		b = t
	return '%d-%d' % [a, b]

