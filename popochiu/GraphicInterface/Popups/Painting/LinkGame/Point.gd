tool
extends Sprite

const UP    = 0b1000
const RIGHT = 0b0100
const DOWN  = 0b0010
const LEFT  = 0b0001

const TOTEM_MAP = {
	'BEE': 23,
	'BEETLE': 20,
	'LADY_BUG': 22,
	'ROOSTER': 21,
	'TOTEM': 24
}

# can move to: up=8, right=4, down=2, left=1
export var is_start_point = false setget set_start_point
export var original_moves = 0b1111 setget set_original_moves
export var coords = Vector2(0, 0) setget set_coords
export(String, '', 'BEE', 'BEETLE', 'LADY_BUG', 'ROOSTER', 'TOTEM') var totem = '' setget set_totem
var free_moves = 0b1111
var _entry_direction = 0 setget set_entry_direction



signal clicked
signal mouse_entered
signal mouse_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	print(free_moves)
	$Area2D.connect('input_event', self, '_on_input')
	$Area2D.connect('mouse_entered', self, 'emit_signal', ['mouse_entered', self])
	$Area2D.connect('mouse_exited', self, 'emit_signal', ['mouse_exited', self])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

static func get_oposite(direction):
	match direction:
		UP: return DOWN
		DOWN: return UP
		LEFT: return RIGHT
		RIGHT: return LEFT

func _on_input(viewport: Object, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		emit_signal('clicked', self)


func can_move_to(direction):
	return free_moves & direction > 0

func lock_move(direction):
	free_moves = free_moves ^ direction

func unlock_move(direction):
	free_moves = free_moves | direction

func set_original_moves(_moves):
	original_moves = _moves
	free_moves = original_moves
	self.frame = original_moves

func neighbour_direction(_point):
	if coords.x == _point.coords.x:
		if coords.y - _point.coords.y == 1:
			return DOWN
		elif coords.y - _point.coords.y == -1:
			return UP
	elif coords.y == _point.coords.y:
		if coords.x - _point.coords.x == 1:
			return RIGHT
		elif coords.x - _point.coords.x == -1:
			return LEFT
	return 0

func set_start_point(_is_start):
	is_start_point = _is_start
	if _is_start:
		$Decoration.visible = true
		$Decoration.frame = 16

func set_entry_direction(_entry):
	_entry_direction = _entry

func set_coords(_coords):
	coords = _coords
	position.x = coords.x * 15
	position.y = coords.y * 15

func set_totem(_totem):
	totem = _totem
	if totem.empty():
		$Decoration.visible = false
		return
	$Decoration.visible = true
	$Decoration.frame = TOTEM_MAP[_totem]
