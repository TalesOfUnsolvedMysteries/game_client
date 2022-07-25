extends Resource

class_name DungeonResource

export(int) var _seed = 1 setget set_seed
export(int, 1, 100) var _width = 16 setget set_width
export(int, 1, 100) var _height = 8 setget set_height

export(int, 1, 100) var _max_initial_room_width = 5 setget set_max_initial_room_width
export(int, 1, 100) var _max_initial_room_height = 4  setget set_max_initial_room_height
export(float, 0.0, 1.0, 0.01) var _merge_grid_chance = 1.0 setget set_merge_grid_chance

export(int, 1, 1000) var _min_number_rooms = 4 setget set_min_number_rooms
export(int, 1, 1000) var _max_number_rooms = 16 setget set_max_number_rooms

export(bool) var _random_merge = true setget set_random_merge
export(float, 0.0, 1.0, 0.01) var _select_room_chance = 0.6 setget set_select_room_chance
export(float, 0.0, 1.0, 0.01) var _merge_room_chance = 0.4 setget set_merge_room_chance


export(int, 1000) var _max_deep = 10 setget set_max_deep
export(float, 0.0, 1.0, 0.01) var _survival_door_chance = 0.1 setget set_survival_door_chance

export(Vector2) var _start_position = Vector2(-1, -1) setget set_start_position


func set_seed(val):
	_seed = val
	emit_signal('changed')
	
func set_width(val):
	_width = val
	emit_signal('changed')
	
func set_height(val):
	_height = val
	emit_signal('changed')
	
func set_max_initial_room_width(val):
	_max_initial_room_width = val
	emit_signal('changed')
	
func set_max_initial_room_height(val):
	_max_initial_room_height = val
	emit_signal('changed')
	
func set_merge_grid_chance(val):
	_merge_grid_chance = val
	emit_signal('changed')
	
func set_random_merge(val):
	_random_merge = val
	emit_signal('changed')

func set_min_number_rooms(val):
	_min_number_rooms = val
	emit_signal('changed')
	
func set_max_number_rooms(val):
	_max_number_rooms = val
	emit_signal('changed')
	
func set_select_room_chance(val):
	_select_room_chance = val
	emit_signal('changed')
	
func set_merge_room_chance(val):
	_merge_room_chance = val
	emit_signal('changed')
	
func set_max_deep(val):
	_max_deep = val
	emit_signal('changed')
	
func set_survival_door_chance(val):
	_survival_door_chance = val
	emit_signal('changed')
	
func set_start_position(val):
	_start_position = val
	emit_signal('changed')

