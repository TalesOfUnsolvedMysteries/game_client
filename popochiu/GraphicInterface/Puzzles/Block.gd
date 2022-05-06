extends Area2D

class_name PuzzleBlock

var hover = false
var dragged = false
var move_x = false
var move_y = false
var boundaries_x = Vector2(-40, 40)
var boundaries_y = Vector2(-40, 40)
var _matched = false
var locked = false
export var lock_on_match = true


var offset = Vector2(0,0)
export var tile_position = Vector2(0, 0) setget set_tile_position
export var size = Vector2(1, 1) setget set_size
export var target_tile = Vector2(-1, -1) setget set_target_tile
var _drag_point

signal drag_started
signal drag_ended
signal target_entered
signal target_exited

func _ready():
	connect('mouse_entered', self, '_set_hover', [true])
	connect('mouse_exited', self, '_set_hover', [false])

func _set_hover(_hover):
	hover = _hover

func set_tile_position(_tile_position):
	tile_position = _tile_position
	position.x = tile_position.x * 20 + offset.x
	position.y = tile_position.y * 20 + offset.y
	
	if tile_position == target_tile:
		_matched = true


func _unhandled_input(event):
	var mouse_event: = event as InputEventMouseButton
	if locked: return
	if mouse_event:
		var _drag = hover and mouse_event.pressed
		# starts dragging
		if _drag && !dragged:
			on_picked()
			get_tree().set_input_as_handled()
		# stops dragging
		if !_drag && dragged:
			Utils.invoke(self, 'on_dropped')
			get_tree().set_input_as_handled()


func on_picked():
	_drag_point = position - get_global_mouse_position()
	dragged = true
	$CollisionShape2D.modulate = Color.blue
	
	Utils.invoke(self, 'emit_signal', ['drag_started', self])
	A.play({
		cue_name = 'sfx_puzzle_slide_loop',
		is_in_queue = false
	})


func on_dropped():
	A.stop('sfx_puzzle_slide_loop', 0, false, true, 0.3)
	_progressive_volume = -50
	move_x = false
	move_y = false
	dragged = false
	tile_position.x = round((position.x - offset.x)/20)
	tile_position.y = round((position.y - offset.y)/20)
	emit_signal('drag_ended', self)
	position.x = tile_position.x*20 + offset.x
	position.y = tile_position.y*20 + offset.y
	$CollisionShape2D.modulate = Color.white
	if tile_position == target_tile:
		_matched = true
		emit_signal('target_entered')
		$CollisionShape2D.modulate = Color.black
		locked = lock_on_match
	elif _matched:
		_matched = false
		emit_signal('target_exited')

var _target_position
var _progressive_volume = -50
func _process(delta):
	if !dragged: return
	_target_position = get_global_mouse_position() + _drag_point
	if !move_x && !move_y && position !=_target_position:
		move_x = abs(position.x - _target_position.x) > abs(position.y - _target_position.y)
		move_y = !move_x
	
	var _speed = abs(position.x - clamp(_target_position.x, boundaries_x[0], boundaries_x[1])) + abs(position.y - clamp(_target_position.y, boundaries_y[0], boundaries_y[1]))
	if _speed > 0:
		_progressive_volume += _speed*3
	else:
		_progressive_volume -= 1

	_progressive_volume = clamp(_progressive_volume, -50, 0)
	A.change_cue_volume('sfx_puzzle_slide_loop', _progressive_volume)
	if move_x: position.x = _target_position.x
	if move_y: position.y = _target_position.y
	
	Utils.invoke(
		self,
		'set_position',
		[Vector2(
			clamp(position.x, boundaries_x[0], boundaries_x[1]),
			clamp(position.y, boundaries_y[0], boundaries_y[1])
		)]
	)


func set_size(_size):
	size = _size
	print(size)
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.extents.x = size.x * 10
	$CollisionShape2D.shape.extents.y = size.y * 10
	$CollisionShape2D.position.x = (size.x - 1) * 10
	$CollisionShape2D.position.y = (size.y - 1) * 10


func set_target_tile(_target):
	target_tile = _target


func set_texture(txt: Texture) -> void:
	$Sprite.texture = txt

func reset():
	_matched = false
	locked = false
