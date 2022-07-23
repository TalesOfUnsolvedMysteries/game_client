extends Node

class_name DungeonUtils

static func merge_doors(doors: Dictionary, key_a, key_b):
	var a_door = doors.get(key_a)
	var b_door = doors.get(key_b)
	if (not a_door) or (not b_door): return
	# check if doors are in the same axis
	var merge_positions = (a_door.x == b_door.x or a_door.y == b_door.y)
	# random choice
	var pos = randf()
	var new_door = (a_door*pos + b_door*(1.0-pos))
	if not merge_positions:
		new_door = a_door if pos > 0.5 else b_door
	doors[key_a] = new_door
	doors.erase(key_b)


static func merge_rooms(dungeon: Dungeon, key_a, key_b):
	var rooms:Dictionary = dungeon.rooms
	var adjacency_matrix:Array = dungeon.adjacency_matrix
	var doors:Dictionary = dungeon.doors
	
	var keys: Array = rooms.keys()
	var a_index = keys.find(key_a)
	var b_index = keys.find(key_b)

	for j in adjacency_matrix.size():
		var edge_key = keys[j]
		var existing_edge = adjacency_matrix[j][b_index]
		if key_a != edge_key and existing_edge == 1:
			var door_a_edge_key = DungeonDoor.get_key_for(key_a, edge_key)
			var door_b_edge_key = DungeonDoor.get_key_for(key_b, edge_key)
			if adjacency_matrix[j][a_index] == 1:
				merge_doors(doors, door_a_edge_key, door_b_edge_key)
			elif doors.has(door_b_edge_key):
				doors[door_a_edge_key] = doors[door_b_edge_key]
				doors.erase(door_b_edge_key)
		
		adjacency_matrix[j][a_index] |= adjacency_matrix[j][b_index]
		adjacency_matrix[a_index][j] |= adjacency_matrix[b_index][j]
		adjacency_matrix[j][b_index] = 0
		adjacency_matrix[b_index][j] = 0
	adjacency_matrix[a_index][a_index] = 0
	# update room graph
	for j in adjacency_matrix.size():
		var node_key = keys[j]
		rooms[node_key]['edges'] = []
		for i in adjacency_matrix[j].size():
			var edge_key = keys[i]
			if adjacency_matrix[j][i] == 1:
				rooms[node_key]['edges'].push_back(edge_key)
		adjacency_matrix[j].remove(b_index)
	adjacency_matrix.remove(b_index)
	doors.erase(DungeonDoor.get_key_for(key_a, key_b))
	rooms[key_a].squares.append_array(rooms[key_b].squares)
	rooms.erase(key_b)
