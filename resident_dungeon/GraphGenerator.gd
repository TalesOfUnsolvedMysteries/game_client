extends Node

func build_tree_b(dungeon: Dungeon):
	var temp_matrix:Array = dungeon.adjacency_matrix.duplicate(true)
	var result_matrix:Array = dungeon.adjacency_matrix.duplicate(true)
	var keys = dungeon.rooms.keys()
	var _max_deep = dungeon.configuration._max_deep
	var starting_room_key = DungeonUtils.get_room_for_point(dungeon, dungeon.configuration._start_position)
	if starting_room_key == -1: starting_room_key = keys[randi()%keys.size()]
	var starting_room_index = keys.find(starting_room_key)
	dungeon.set_root_node(starting_room_key)
	var visited = [starting_room_key]
	var index = 0
	for i in keys.size():
		for j in keys.size():
			result_matrix[j][i]=0

	while index < visited.size():
		var key = visited[index]
		var room_index = keys.find(key)
		var path = get_path_for(dungeon, key, visited)
		visited.append_array(path)
		for edge_key in path:
			var edge_index = keys.find(edge_key)
			DungeonUtils.enable_door(dungeon, result_matrix, room_index, edge_index)
		index += 1
	
	while visited.size() < keys.size():
		var excluded = []
		var excluded_indexes = []
		for key in keys:
			if not visited.has(key):
				excluded.push_back(key)
				excluded_indexes.push_back(keys.find(key))
		visited.shuffle()
		for key in visited:
			var visited_index = keys.find(key)
			var connections = dungeon.adjacency_matrix[visited_index]
			for i in keys.size():
				if connections[i] == 1 and excluded_indexes.find(i) != -1 and randf() < 0.1 and visited.find(keys[i]) == -1:
					DungeonUtils.enable_door(dungeon, result_matrix, visited_index, i)
					visited.push_back(keys[i])

	return result_matrix

func get_path_for(dungeon: Dungeon, room_id: int, excluded: Array):
	var room: DungeonRoom = dungeon.get_room(room_id)
	var edges = room.edges.duplicate(true)
	for parent_key in excluded:
		edges.erase(parent_key)
	edges.shuffle()
	for edge in edges:
		if randf() < 0.7:
			edges.erase(edge)
	return edges
	

func build_tree(dungeon: Dungeon):
	var temp_matrix:Array = dungeon.adjacency_matrix.duplicate(true)
	var result_matrix:Array = []
	var keys = dungeon.rooms.keys()
	var _max_deep = dungeon.configuration._max_deep
	var _survival_door_chance = dungeon.configuration._survival_door_chance
	var starting_room_key = DungeonUtils.get_room_for_point(dungeon, dungeon.configuration._start_position)
	if starting_room_key == -1: starting_room_key = keys[randi()%keys.size()]
	var starting_room_index = keys.find(starting_room_key)
	var _visited_nodes:Array = [starting_room_index]
	var _deep_map: Array = [0]
	var _tree_node_index = 0
	var _exploration_index = 0
	var deep = 0
	
	dungeon.set_root_node(starting_room_key)
	
	for i in keys.size():
		result_matrix.push_back([])
		for j in keys.size():
			result_matrix[i].push_back(0)

	while _tree_node_index < _visited_nodes.size():
		if _exploration_index >= _visited_nodes.size(): break
		var _index_node = _visited_nodes[_exploration_index]
		var _node = keys[_index_node]

		var edge_index = _get_random_edge(temp_matrix, _index_node, _visited_nodes)
		if edge_index == -1 or deep >= _max_deep:
			deep = _deep_map[_tree_node_index]
			if edge_index == -1:
				_tree_node_index += 1
			if deep >= _max_deep:
				_exploration_index += 1
				if _exploration_index >= _visited_nodes.size():
					_exploration_index = 0
					_max_deep += 1
				deep = _deep_map[_exploration_index]
			else:
				_exploration_index = _tree_node_index
			if _tree_node_index >= _visited_nodes.size() and _visited_nodes.size() < keys.size():
				_tree_node_index = 0
				_exploration_index = 0
				deep = _deep_map[_exploration_index]
			continue
		# choose one edge at random
		_visited_nodes.push_back(edge_index)
		deep += 1
		_deep_map.push_back(deep)
		temp_matrix[edge_index][_index_node] = 0
		temp_matrix[_index_node][edge_index] = 0
		result_matrix[edge_index][_index_node] = 1
		result_matrix[_index_node][edge_index] = 1
		var key = DungeonDoor.get_key_for(keys[edge_index], keys[_index_node])
		var door = dungeon.doors[key]
		door.enabled = true
		_exploration_index += 1
	
	for j in range(0, keys.size()):
		var a_key = keys[j]
		for i in range(j, keys.size()):
			var b_key = keys[i]
			var key = DungeonDoor.get_key_for(a_key, b_key)
			if result_matrix[j][i] == 0:
				if dungeon.doors.has(key) and _survival_door_chance > randf():
					result_matrix[j][i] = 1
					result_matrix[i][j] = 1
					var door = dungeon.doors[key]
					door.enabled = true
	
		
	return result_matrix


func _get_random_edge(adjacency_matrix:Array, index, excluded: Array):
	var selected_array = []
	for i in range(0, adjacency_matrix.size()):
		if adjacency_matrix[index][i] == 1 and (not excluded.has(i)):
			selected_array.push_back(i)
	if selected_array.size() == 0: return -1
	return selected_array[randi()%selected_array.size()]

