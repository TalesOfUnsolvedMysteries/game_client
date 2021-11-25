extends Area2D

class_name PuzzleBlock

var hover = false
var dragged = false
var move_x = false
var move_y = false
var boundaries_x = Vector2(-40, 40)
var boundaries_y = Vector2(-40, 40)

var offset = Vector2(0,0)
export var tile_position = Vector2(0, 0) setget set_tile_position
export var size = Vector2(1, 1) setget set_size

var _drag_point

signal drag_started
signal drag_ended

func _ready():
	connect('mouse_entered', self, '_set_hover', [true])
	connect('mouse_exited', self, '_set_hover', [false])

func _set_hover(_hover):
	hover = _hover

func set_tile_position(_tile_position):
	tile_position = _tile_position
	position.x = tile_position.x * 20 + offset.x
	position.y = tile_position.y * 20 + offset.y


func _unhandled_input(event):
	var mouse_event: = event as InputEventMouseButton 
	if mouse_event:
		var _drag = hover and mouse_event.pressed
		# starts dragging
		if _drag && !dragged:
			_drag_point = position - get_global_mouse_position()
			dragged = _drag
			emit_signal('drag_started', self)
		# stops dragging
		if !_drag && dragged:
			move_x = false
			move_y = false
			dragged = _drag
			tile_position.x = round((position.x - offset.x)/20)
			tile_position.y = round((position.y - offset.y)/20)
			emit_signal('drag_ended', self)
			position.x = tile_position.x*20 + offset.x
			position.y = tile_position.y*20 + offset.y

var _target_position
func _process(delta):
	if !dragged: return
	_target_position = get_global_mouse_position() + _drag_point
	if !move_x && !move_y && position !=_target_position:
		move_x = abs(position.x - _target_position.x) > abs(position.y - _target_position.y)
		move_y = !move_x;
	
	if move_x: position.x = _target_position.x
	if move_y: position.y = _target_position.y
	position.x = clamp(position.x, boundaries_x[0], boundaries_x[1])
	position.y = clamp(position.y, boundaries_y[0], boundaries_y[1])


func set_size(_size):
	size = _size
	print(size)
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.extents.x = size.x * 10
	$CollisionShape2D.shape.extents.y = size.y * 10
	$CollisionShape2D.position.x = (size.x - 1) * 10
	$CollisionShape2D.position.y = (size.y - 1) * 10
