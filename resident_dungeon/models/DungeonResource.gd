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

# level special characteristics
export(int, 'NONE', 'NORMAL', 'END') var _exit = 1 setget set_exit
export(String) var _boss_code = '' setget set_boss_code
export(Array, Dictionary) var _loot_contents = [] setget set_loot_contents
export(Array, String) var _special_items = [] setget set_special_items
export(String) var _terminal_code = '' setget set_terminal_code
export(int) var _safe_rooms = 0 setget set_safe_rooms
export(String) var _survivor_code = '' setget set_survivor_code
export(int) var _locked_rooms = 0 setget set_locked_rooms
export(Array, DungeonRoom.Types) var _dark_rooms = [] setget set_dark_rooms
export(bool) var _lock_dark_paths = true setget set_lock_dark_paths

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

func set_exit(val):
	_exit = val
	emit_signal('changed')

func set_boss_code(val):
	_boss_code = val
	emit_signal('changed')

func set_loot_contents(val):
	_loot_contents = val
	emit_signal('changed')

func set_special_items(val):
	_special_items = val
	emit_signal('changed')

func set_terminal_code(val):
	_terminal_code = val
	emit_signal('changed')

func set_safe_rooms(val):
	_safe_rooms = val
	emit_signal('changed')

func set_survivor_code(val):
	_survivor_code = val
	emit_signal('changed')

func set_locked_rooms(val):
	_locked_rooms = val
	emit_signal('changed')

func set_dark_rooms(val):
	_dark_rooms = val
	emit_signal('changed')
	
func set_lock_dark_paths(val):
	_lock_dark_paths = val
	emit_signal('changed')




