extends Sprite

var _playing = false
var _position = Vector2(0.0, 0.0)
var _cell = -1
var tilemap: TileMap = null setget set_tilemap

var _current_cell_coordinates = Vector2(0, 0)

signal validation_failed
signal goal_reached
signal point_collected

func _ready():
	_position = self.position
	$Tween.interpolate_property(self, 'modulate:a', 1.0, 0.5, 0.5, Tween.TRANS_BOUNCE)
	$Tween.start()

func set_tilemap(_tilemap):
	tilemap = _tilemap
	tilemap.connect('frame_updated', self, '_check_cell')

func start(_position):
	_playing = true
	self.position = _position
	_current_cell_coordinates = self.position/6.0
	visible = true


func move_left():
	_move_to(_current_cell_coordinates + Vector2(-1,  0))

func move_right():
	_move_to(_current_cell_coordinates + Vector2(1,  0))

func move_up():
	_move_to(_current_cell_coordinates + Vector2(0,  -1))

func move_down():
	_move_to(_current_cell_coordinates + Vector2(0,  1))

func _move_to(_target_pos):
	if not _playing:
		return
	var _target_cell = tilemap.get_cellv(_target_pos)
	
	match _target_cell:
		-1: 
			_update_cell(_target_pos)
		1:
			_update_cell(_target_pos)
		8:
			_update_cell(_target_pos)
			emit_signal('validation_failed')
			_playing = false
		13:
			_update_cell(_target_pos)
			emit_signal('validation_failed')
			_playing = false
		11:
			_update_cell(_target_pos)
			_playing = false
			emit_signal('goal_reached')
		15:
			_update_cell(_target_pos)
			tilemap.set_cellv(_target_pos, 1)
			emit_signal('point_collected')

func _update_cell(_target_pos):
	_current_cell_coordinates = _target_pos
	position = _target_pos * 6.0

func _check_cell():
	_move_to(_current_cell_coordinates)
