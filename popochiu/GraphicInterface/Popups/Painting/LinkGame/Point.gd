tool
extends Sprite

class_name LinkPoint

const UP    = 0b1000
const RIGHT = 0b0100
const DOWN  = 0b0010
const LEFT  = 0b0001

const TOTEM_MAP = {
	'BEE': 23,
	'BEETLE': 20,
	'LADY_BUG': 22,
	'ROOSTER': 21,
	'TOTEM': 24,
	'0': 25,
	'1': 26,
	'2': 27,
	'3': 28,
	'4': 29,
	'5': 30,
	'6': 31,
	'7': 32
}

# can move to: up=8, right=4, down=2, left=1
export var is_start_point = false setget set_start_point
export var original_moves = 0b1111 setget set_original_moves
export var coords = Vector2(0, 0) setget set_coords
export(String, '', '0', '1', '2', '3', '4', '5', '6', '7', 'BEE', 'BEETLE', 'LADY_BUG', 'ROOSTER', 'TOTEM') var totem = '' setget set_totem
var free_moves = 0b1111
var _entry_direction = 0 setget set_entry_direction

onready var collider = get_node('Area2D')

signal clicked
signal mouse_entered
signal mouse_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	collider.connect('input_event', self, '_on_input')
	collider.connect('mouse_entered', self, 'emit_signal', ['mouse_entered', self])
	collider.connect('mouse_exited', self, 'emit_signal', ['mouse_exited', self])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

static func get_oposite(direction):
	match direction:
		UP: return DOWN
		DOWN: return UP
		LEFT: return RIGHT
		RIGHT: return LEFT
	return 0

func _on_input(viewport: Object, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		emit_signal('clicked', self)


func can_move_to(direction):
	return (free_moves & direction) > 0

func lock_move(direction):
	free_moves = free_moves ^ direction

func unlock_move(direction):
	free_moves = free_moves | direction

func set_original_moves(_moves):
	original_moves = _moves
	free_moves = original_moves
	self.frame = original_moves

func neighbour_direction(_point):
	var _direction = 0
	if coords.x == _point.coords.x:
		if coords.y - _point.coords.y == 1:
			_direction = DOWN
		elif coords.y - _point.coords.y == -1:
			_direction = UP
	elif coords.y == _point.coords.y:
		if coords.x - _point.coords.x == 1:
			_direction = RIGHT
		elif coords.x - _point.coords.x == -1:
			_direction = LEFT
	if not can_move_to(get_oposite(_direction)):
		_direction = 0
	return _direction


func set_start_point(_is_start):
	is_start_point = _is_start

func set_entry_direction(_entry):
	_entry_direction = _entry

func set_coords(_coords):
	coords = _coords
	position.x = coords.x * 15
	position.y = coords.y * 15

func set_totem(_totem):
	totem = _totem
	$Decoration.visible = false
	if totem.empty(): return
	
	is_start_point = '01234567'.find(_totem) != -1
	$Decoration.visible = true
	$Decoration.frame = TOTEM_MAP[_totem]

func toggle_edge(_position: Vector2):
	var _distance = _position.distance_to(global_position)
	print(_distance)
	if _distance < 4 or _distance > 10: return
	var _angle = get_angle_to(_position) + PI

	if _angle >= PI/4 and _angle < 3*PI/4:
		set_original_moves(original_moves ^ UP)
	elif _angle >= 3*PI/4 and _angle < 5*PI/4:
		set_original_moves(original_moves ^ RIGHT)
	elif _angle >= 5*PI/4 and _angle < 7*PI/4:
		set_original_moves(original_moves ^ DOWN)
	else:
		set_original_moves(original_moves ^ LEFT)


