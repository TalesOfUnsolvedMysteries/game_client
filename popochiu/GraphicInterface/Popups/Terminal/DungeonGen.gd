extends Node2D

export(int) var _width = 16
export(int) var _height = 8
export(int) var _seed = 1 setget set_seed

export(int) var _max_initial_room_width = 5
export(int) var _max_initial_room_height = 4
export(float) var _merge_grid_chance = 1.0

export(bool) var _random_merge = true
export(int) var _random_merge_iterations = 6
export(int) var _min_number_rooms = 4
export(int) var _max_number_rooms = 16
#export(bool) var _allow_one_x_one_rooms = true # maybe later

export(float) var _select_room_chance = 0.6 # export
export(float) var _merge_room_chance = 0.4 # export

onready var buttons = find_node('buttons')

var dungeon = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	$Control/Generate.connect('button_down', self, '_on_generate_pressed')
	$Control/Generate2.connect('button_down', self, '_on_generate2_pressed')
	$Control/Generate3.connect('button_down', self, '_on_generate3_pressed')
	$Control/Generate4.connect('button_down', self, '_on_generate4_pressed')
	$Control/Merge.connect('button_down', self, '_on_merge_pressed')


func generate():
	seed(_seed)

	# build basic grid
	var basic_grid := []
	var doors := {}
	var index = 0
	for j in range(0, _height):
		for i in range(0, _width):
			# index, i, j, edge_indexes, width, height, child_rooms
			var room_node = [index, i, j, [], 1, 1,[]]
			if j != 0:
				room_node[3].push_back(index - _width)
				add_door(doors, index, index - _width, 0)
			if i != 0:
				room_node[3].push_back(index - 1)
				add_door(doors, index, index - 1, 1)
			if i != _width - 1:
				room_node[3].push_back(index + 1)
				add_door(doors, index, index + 1, 1)
			if j != _height - 1:
				room_node[3].push_back(index + _width)
				add_door(doors, index, index + _width, 0)
			basic_grid.push_back(room_node)
			index += 1

	# generate squares
	var room_graph = {}
	for cell in basic_grid:
		if cell[3][0] == -1: continue	# already merged
		if randf() > _merge_grid_chance: continue
		var orientation = randf() > 0.5
		var _min_width = 1 if orientation else 2
		var _min_height = 1 if not orientation else 2
		# merge
		index = cell[0]
		var i = cell[1]
		var j = cell[2]
		var w = clamp(i + _min_width + (randi() % (_max_initial_room_width-_min_width)), i + _min_width, _width)
		var h = clamp(j + _min_height + (randi() % (_max_initial_room_height-_min_height)), j + _min_height, _height)

		for _j in range(j, h):
			for _i in range(i, w):
				var _merge_index = (_j * _width) + _i
				var _to_merge = basic_grid[_merge_index]
				if _to_merge[3][0] == -1:
					if _i <= w:
						w = _i
					break
				
		cell[4] = w - i
		cell[5] = h - j
		
		for _j in range(j, h):
			for _i in range(i, w):
				var _merge_index = (_j * _width) + _i
				if _merge_index == index: continue
				var _to_merge = basic_grid[_merge_index]
				if _to_merge[3][0] == -1: continue
				# merge with next cells
				merge_room_doors(doors, basic_grid, index, _merge_index, cell[3], _to_merge[3])
				cell[3].erase(_merge_index)	# remove conection to that cell
				_to_merge[3].erase(index)	# remove conection in cell to merge
				cell[3].append_array(_to_merge[3])
				_to_merge[3] = [-1, index]
	
	# a graph room:
	# room: key
	# 		squares: [[i, j, w, h]
	# adjacency matrix
	# doors
	
	# refine map, transform into graph
	for cell in basic_grid:
		if cell[3][0] == -1: continue	# already merged
		var filtered_edges: Array = []
		for _edge_index in cell[3]:
			var _edge_cell = basic_grid[_edge_index]
			while _edge_cell[3][0] == -1:
				_edge_index = _edge_cell[3][1]
				_edge_cell = basic_grid[_edge_index]
			if not filtered_edges.has(_edge_index) and _edge_index != cell[0]:
				filtered_edges.push_back(_edge_index)
		var key = cell[0]
		var base_square = [cell[1], cell[2], cell[4], cell[5]]
		room_graph[key] = {'key': key, 'squares': [base_square], 'edges': filtered_edges}
	var adjacency_matrix = get_adjacency_matrix_from(room_graph)
	decorate_dungeon_graph(room_graph)
	dungeon = {
		'room_graph': room_graph,
		'adjacency_matrix': adjacency_matrix,
		'doors': doors
	}


func merge_rooms(key_a, key_b):
	var room_graph:Dictionary = dungeon['room_graph']
	var adjacency_matrix:Array = dungeon['adjacency_matrix']
	var doors:Dictionary = dungeon['doors']
	
	var keys: Array = room_graph.keys()
	var a_index = keys.find(key_a)
	var b_index = keys.find(key_b)

	for j in adjacency_matrix.size():
		var edge_key = keys[j]
		var existing_edge = adjacency_matrix[j][b_index]
		if key_a != edge_key and existing_edge == 1:
			var door_a_edge_key = get_door_key(key_a, edge_key)
			var door_b_edge_key = get_door_key(key_b, edge_key)
			if adjacency_matrix[j][a_index] == 1:
				merge_doors(doors, door_a_edge_key, door_b_edge_key)
			else:
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
		room_graph[node_key]['edges'] = []
		for i in adjacency_matrix[j].size():
			var edge_key = keys[i]
			if adjacency_matrix[j][i] == 1:
				room_graph[node_key]['edges'].push_back(edge_key)
		adjacency_matrix[j].remove(b_index)
	adjacency_matrix.remove(b_index)
	doors.erase(get_door_key(key_a, key_b))
	room_graph[key_a].squares.append_array(room_graph[key_b].squares)
	room_graph.erase(key_b)


func random_merge():
	generate()
	var keys = dungeon.room_graph.keys()
	if keys.size() <= _min_number_rooms: return
	var iterations = keys.size() - _min_number_rooms if keys.size() - _random_merge_iterations < _min_number_rooms else _random_merge_iterations
	for i in range(0, iterations):
		random_merge_step()

func chance_merge():
	generate()
	var keys = dungeon.room_graph.keys()
	#if keys.size() <= _min_number_rooms: return
	for key in keys:
		if not dungeon.room_graph.has(key): continue
		if randf() > _select_room_chance: continue
		var room = dungeon.room_graph[key]
		for edge in room.edges:
			if randf() > _merge_room_chance: continue
			merge_rooms(key, edge)
			if dungeon.room_graph.size() <= _min_number_rooms:
				return

func random_merge_step():
	var keys = dungeon['room_graph'].keys()
	var key = keys[randi()%keys.size()]
	print(key)
	var edges = dungeon['room_graph'][key]['edges']
	if edges.size() == 0: return
	var edge = edges[randi()%edges.size()]
	merge_rooms(key, edge)


func print_full_data_dungeon():
	print_dungeon(dungeon['room_graph'])
	var str_matrix = ''
	for j in dungeon['adjacency_matrix'].size():
		for i in dungeon['adjacency_matrix'][j].size():
			str_matrix += str(dungeon['adjacency_matrix'][j][i])
		str_matrix += '\n'


func get_adjacency_matrix_from(room_graph: Dictionary):
	var keys = room_graph.keys()
	var matrix = []
	var index = 0
	for key in keys:
		matrix.push_back([])
		var edges:Array = room_graph[key]['edges']
		for _key in keys:
			matrix[index].push_back(1 if edges.has(_key) else 0)
		index += 1
	return matrix


func add_door(doors, a, b, vertical):
	var key = get_door_key(a, b)
	if doors.has(key): return
	var coords_a = Vector3(a%_width, floor(a/_width), vertical)
	var coords_b = Vector3(b%_width, floor(b/_width), vertical)
	doors[key] = coords_b*0.5 + coords_a*0.5

func get_door_key(a, b):
	if b < a:
		var t = a
		a = b
		b = t
	return '%d-%d' % [a, b]

func get_door(doors: Dictionary, a, b):
	var key = get_door_key(a, b)
	return doors.get(key)

func merge_doors(doors: Dictionary, key_a, key_b):
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

func get_index_for_room(basic_grid, index):
	var room = basic_grid[index]
	return room[3][1] if room[3][0] == -1 else index

func merge_room_doors(doors: Dictionary, basic_grid:Array, a, b, a_edges: Array, b_edges: Array):

	# door a-b must dissapear
	var merged_door_key = get_door_key(a, b)
	doors.has(merged_door_key) and doors.erase(merged_door_key)

	var index = 0
	for a_edge in a_edges:
		a_edges[index] = get_index_for_room(basic_grid, a_edge)
		index+=1
	index = 0
	for b_edge in b_edges:
		b_edges[index] = get_index_for_room(basic_grid, b_edge)
		index+=1
	
	for b_edge in b_edges:
		# check real edge
		#b_edge = get_index_for_room(basic_grid, b_edge)
		var a_bedge_key = get_door_key(a, b_edge)
		var b_bedge_key = get_door_key(b, b_edge)
		# for each door c in common for a and b:
		if a == b_edge: continue
		if a_edges.has(b_edge):
			# door a-c b-c must be merged into one of the two or an intersection
			merge_doors(doors, a_bedge_key, b_bedge_key)
		elif doors.has(b_bedge_key):
			# doors b-d and d not in a must be remaped as a-d
			doors[a_bedge_key] = doors[b_bedge_key]
			doors.erase(b_bedge_key)

func decorate_dungeon_graph(room_graph):
	var node_keys:Array = room_graph.keys()
	node_keys.shuffle()
	var codes:String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	var index = 1.0
	for key in node_keys:
		var room = room_graph[key]
		var code_key = codes[(int(index))%(codes.length())]
		var color_key = Color.from_hsv(index/node_keys.size(), 0.67, 0.9)
		room['label'] = '[color=#%s]%s[/color]' % [color_key.to_html(false), code_key]
		room['code_key'] = code_key
		index += 1.0

func print_dungeon(room_graph):
	var basic_grid = []
	var node_keys:Array = room_graph.keys()

	for j in range(0, _height):
		basic_grid.push_back([])
		for i in range(0, _width):
			basic_grid[j].push_back(' ')
	
	# {'key': key, 'squares': [base_square], 'edges': filtered_edges}
	for key in node_keys:
		var room = room_graph[key]
		for square in room['squares']:
			for i in range(square[0], square[0] + square[2]):
				for j in range(square[1], square[1] + square[3]):
					basic_grid[j][i] = key
	
	for child_button in buttons.get_children():
		buttons.remove_child(child_button)
	
	for key in node_keys:
		var room = room_graph[key]
		var _btn = Button.new()
		_btn.text = str(room.code_key)
		_btn.connect("button_down", self, '_load_node', [room_graph, key])
		buttons.add_child(_btn)
	
	var _dungeon_str = ''
	for j in range(0, _height):
		for i in range(0, _width):
			var key = basic_grid[j][i]
			var room = room_graph[key]
			_dungeon_str += room.label
		_dungeon_str += '\n'
	$Control/RichTextLabel.bbcode_text = '[code]%s[/code]' % _dungeon_str


func _load_node(room_graph, key):
	$Control/RichTextLabel.text = str(room_graph[key])

func set_seed(__seed):
	_seed = __seed
	if buttons: generate()

func _on_generate_pressed():
	generate()
	print_full_data_dungeon()

func _on_generate2_pressed():
	random_merge()
	print_full_data_dungeon()

func _on_generate3_pressed():
	chance_merge()
	print_full_data_dungeon()

func generate_dungeon():
	if _random_merge:
		random_merge()
	else:
		chance_merge()
	var room_overflow = dungeon.room_graph.size() - _max_number_rooms
	if room_overflow > 0:
		for i in range(0, room_overflow):
			random_merge_step()
	
func _on_generate4_pressed():
	generate_dungeon()
	print_full_data_dungeon()
	
func _on_merge_pressed():
	random_merge_step()
	print_full_data_dungeon()

