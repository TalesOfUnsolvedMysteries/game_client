extends Node

class_name DungeonUtils

static func merge_doors(doors: Dictionary, key_a, key_b):
	var a_door: DungeonDoor = doors.get(key_a)
	var b_door: DungeonDoor = doors.get(key_b)
	if (not a_door) or (not b_door): return
	var a_door_position = a_door.position
	var b_door_position = b_door.position
	# check if doors are in the same axis
	var merge_positions = a_door.vertical == b_door.vertical and \
		(a_door.vertical and a_door_position.x == b_door_position.x) or \
		((not a_door.vertical) and a_door_position.y == b_door_position.y)
	# random choice

	var move_ratio = randf()
	if merge_positions:
		a_door.position = (a_door_position*move_ratio + b_door_position*(1.0 - move_ratio))
	elif move_ratio > 0.5:
		a_door.position = b_door.position
		a_door.vertical = b_door.vertical
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
	rooms[key_a].merge_with_room(rooms[key_b])
	#rooms[key_a].squares.append_array(rooms[key_b].squares)
	rooms.erase(key_b)

static func enable_door(dungeon, matrix, i, j):
	var keys = dungeon.rooms.keys()
	matrix[j][i] = 1
	matrix[i][j] = 1
	var door_key = DungeonDoor.get_key_for(keys[j], keys[i])
	var door = dungeon.doors[door_key]
	door.enabled = true
	return door


static func get_room_for_point(dungeon: Dungeon, point: Vector2) -> int:
	for key in dungeon.rooms:
		var room: DungeonRoom = dungeon.rooms[key]
		if room.contains_point(point):
			return key
	return -1


static func get_leaves(matrix):
	var leaves = []
	var i = 0
	for node in matrix:
		var total_edges = 0
		for edge in node: total_edges += edge
		if total_edges == 1: leaves.push_back(i)
		i += 1
	return leaves


static func get_deep_matrix(matrix):
	var base = matrix.duplicate(true)
	var deep = matrix.duplicate(true)
	var ones = matrix.duplicate(true)
	var deep_matrix = matrix.duplicate(true) # load 
	
	for x in range(1, base.size()):
		deep = multiply_matrix(base, deep)
		for j in range(0, ones.size()):
			for i in range(0, ones[j].size()):
				ones[j][i] = (1 if (ones[j][i] + deep[j][i])>0 else 0)
				if deep[j][i] > 0 and deep_matrix[j][i] == 0:
					deep_matrix[j][i] = x + 1
		if check_total(ones): break
	return deep_matrix

static func multiply_matrix(matrix_a, matrix_b):
	var matrixc = matrix_a.duplicate(true)
	for j in range(0, matrix_a.size()):
		for i in range(0, matrix_a[j].size()):
			matrixc[j][i] = 0
			for h in range(0, matrix_a.size()):
				matrixc[j][i] += matrix_a[h][i]*matrix_b[j][h]
	return matrixc


static func check_total(ones):
	var total = 0
	for j in range(0, ones.size()):
		for i in range(0, ones[j].size()):
			total += ones[j][i]
	return total == ones.size()*ones[0].size()
