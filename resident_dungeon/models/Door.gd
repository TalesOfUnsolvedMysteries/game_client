extends Resource


class_name DungeonDoor
enum LOCK_TYPE { NONE, KEY, SIDE, ELECTRONIC }

var key: String setget set_key
var position := Vector2(0.0, 0.0)
var vertical := false
var enabled = false
var sides = [0, 0]
var lock_type = LOCK_TYPE.NONE
var lock_code = ''

func _init(_key: String, _position: Vector2, _vertical: bool):
	set_key(_key)
	position = _position
	vertical = _vertical

func set_key(_key):
	key = _key
	sides = []
	for _key in key.split('-'): sides.push_back(int(_key))

func lock_with_key(key_name):
	lock_type = LOCK_TYPE.KEY
	lock_code = key_name

func lock_from_side(locked_side):
	lock_type = LOCK_TYPE.SIDE
	lock_code = locked_side

func get_next_room(current_door):
	print('current_door ', current_door)
	print(sides)
	return sides[1 - sides.find(current_door)]

static func get_key_for(a, b):
	if b < a:
		var t = a
		a = b
		b = t
	return '%d-%d' % [a, b]

