extends Node

func build_tree(dungeon: Dungeon):
	var temp_matrix:Array = dungeon.adjacency_matrix.duplicate(true)
	var result_matrix:Array = []
	var keys = dungeon.rooms.keys()
	var _max_deep = dungeon.configuration._max_deep
	var _survival_door_chance = dungeon.configuration._survival_door_chance
	
	for i in keys.size():
		result_matrix.push_back([])
		for j in keys.size():
			result_matrix[i].push_back(0)

	var _visited_nodes:Array = [randi()%keys.size()]
	var _deep_map: Array = [0]
	var _tree_node_index = 0
	var _exploration_index = 0
	var deep = 0
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
		_exploration_index += 1
	
	for j in range(0, keys.size()):
		var a_key = keys[j]
		for i in range(j, keys.size()):
			var b_key = keys[i]
			var key = DungeonDoor.get_door_key(a_key, b_key)
			if result_matrix[j][i] == 0:
				if dungeon.doors.has(key) and _survival_door_chance > randf():
					result_matrix[j][i] = 1
					result_matrix[i][j] = 1
				else:
					dungeon.doors.erase(key)
	
	# must validate if there is a path between any two pair of nodes
	is_full_connected(dungeon, result_matrix)
	var leaves = get_leaves(result_matrix)
	#print(leaves)


func is_full_connected(dungeon: Dungeon, matrix):
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


func get_leaves(matrix: Array):
	var leaves = []
	var i = 0
	for node in matrix:
		var total_edges = 0
		for edge in node: total_edges += edge
		if total_edges == 1: leaves.push_back(i)
		i += 1
	return leaves


func _get_random_edge(adjacency_matrix:Array, index, excluded: Array):
	var selected_array = []
	for i in range(0, adjacency_matrix.size()):
		if adjacency_matrix[index][i] == 1 and (not excluded.has(i)):
			selected_array.push_back(i)
	if selected_array.size() == 0: return -1
	return selected_array[randi()%selected_array.size()]


func multiply_matrix(matrix_a, matrix_b):
	var matrixc = matrix_a.duplicate(true)
	for j in range(0, matrix_a.size()):
		for i in range(0, matrix_a[j].size()):
			matrixc[j][i] = 0
			for h in range(0, matrix_a.size()):
				matrixc[j][i] += matrix_a[h][i]*matrix_b[j][h]
	return matrixc


func check_total(ones):
	var total = 0
	for j in range(0, ones.size()):
		for i in range(0, ones[j].size()):
			total += ones[j][i]
	return total == ones.size()*ones[0].size()

