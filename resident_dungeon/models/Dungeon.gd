extends Resource

class_name Dungeon

var rooms: Dictionary
var doors: Dictionary
var adjacency_matrix: Array
var configuration: DungeonResource
var root_node := -1 setget set_root_node # room id

func get_room(key) -> DungeonRoom:
	var room: DungeonRoom = rooms.get(key)
	return room

func set_root_node(room_index: int):
	var room := get_room(room_index)
	if root_node != -1:
		var current_root := get_room(room_index)
		current_root.type = DungeonRoom.Types.BASIC
	if room:
		room.type = DungeonRoom.Types.START
	root_node = room_index
