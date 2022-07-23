extends Resource

class_name Dungeon
var rooms: Dictionary
var doors: Dictionary
var adjacency_matrix: Array

var configuration: DungeonResource

func get_room(key) -> DungeonRoom:
	return rooms[key]

