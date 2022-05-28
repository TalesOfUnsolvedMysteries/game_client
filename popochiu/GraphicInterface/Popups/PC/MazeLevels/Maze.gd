extends TileMap

class_name Maze


var _playing = true
var _time = 0
export var speed = 0.25
var _frame = 0
var _animated_groups = []
signal frame_updated

func _ready():
	_load_animated(16)
	_load_animated(17)
	_load_animated(18)
	_load_animated(19)
	_load_animated(20)
	_load_animated(21)

func _load_animated(cell_type):
	var cells = get_used_cells_by_id(cell_type)
	_animated_groups.push_back(cells)
	for _cell_coordinate in cells:
		set_cellv(_cell_coordinate, 1)


func _process(delta):
	if not _playing: return
	_time += delta
	if _time >= speed:
		_time = _time - speed
		_update_animated()


func _update_animated():
	var _previous_frame = _frame
	_frame += 1
	if _frame >= _animated_groups.size():
		_frame = 0
	
	for _cell_coordinate in _animated_groups[_previous_frame]:
		set_cellv(_cell_coordinate, 1)
	for _cell_coordinate in _animated_groups[_frame]:
		set_cellv(_cell_coordinate, 13)
	emit_signal('frame_updated')
