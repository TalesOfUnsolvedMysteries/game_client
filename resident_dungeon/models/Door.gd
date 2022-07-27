extends Resource


class_name DungeonDoor
enum LOCK_TYPE { NONE, KEY, SIDE, ELECTRONIC }

var key: String
var position := Vector2(0.0, 0.0)
var vertical := false
var enabled = false

var lock_type = LOCK_TYPE.NONE
var lock_code = ''

func _init(_key: String, _position: Vector2, _vertical: bool):
	key = _key
	position = _position
	vertical = _vertical

func lock_with_key(key_name):
	lock_type = LOCK_TYPE.KEY
	lock_code = key_name

static func get_key_for(a, b):
	if b < a:
		var t = a
		a = b
		b = t
	return '%d-%d' % [a, b]

