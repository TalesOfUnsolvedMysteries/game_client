extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var buttons = find_node('buttons')

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()


func generate():
	var _width = 12 # to_export
	var _height = 8 # to_export
	# build basic grid
	var basic_grid = []
	var index = 0
	for j in range(0, _height):
		for i in range(0, _width):
			# index, i, j, edge_indexes, width, height, child_rooms
			var room_node = [index, i, j, [], 1, 1,[]]
			if j != 0: room_node[3].push_back(index - _width)
			if i != 0: room_node[3].push_back(index - 1)
			if i != _width - 1: room_node[3].push_back(index + 1)
			if j != _height - 1: room_node[3].push_back(index + _width)
			basic_grid.push_back(room_node)
			index += 1

	randomize()
	# generate squares
	var orientation = randf() > 0.5
	var _max_width = 6 # to_export
	var _max_height = 5 # to_export
	var _merge_grid_chance = 0.9 # to_export
	var room_graph = {}
	for cell in basic_grid:
		if cell[3][0] == -1: continue	# already merged
		if randf() > _merge_grid_chance: continue
		var _min_width = 1 if orientation else 2
		var _min_height = 1 if not orientation else 2
		# merge
		index = cell[0]
		var i = cell[1]
		var j = cell[2]
		var w = clamp(i + _min_width + randi()%(_max_width), i + _min_width, _width)
		var h = clamp(j + _min_height + randi()%(_max_height), j + _min_height, _height)
		# check if width is ok
		for _j in range(j, h):
			for _i in range(i, w):
				var _merge_index = (_j * _width) + _i
				var _to_merge = basic_grid[_merge_index]
				if _to_merge[3][0] == -1:
					w = _i
					continue
				
		cell[4] = w - i
		cell[5] = h - j
		
		for _i in range(i, w):
			for _j in range(j, h):
				var _merge_index = (_j * _width) + _i
				if _merge_index == index: continue
				var _to_merge = basic_grid[_merge_index]
				if _to_merge[3][0] == -1: continue
				# merge with next cells
				cell[3].erase(_merge_index)	# remove conection to that cell
				_to_merge[3].erase(index)	# remove conection in cell to merge
				cell[3].append_array(_to_merge[3])
				_to_merge[3] = [-1, index]

	print('\n\ndungeon step 2')
	var _dungeon_str = ''
	for j in range(0, _height):
		for i in range(0, _width):
			index = j * _width + i
			var cell = basic_grid[index]
			index = cell[3][1] if cell[3][0] == -1 else cell[0]
			_dungeon_str += '%s' % char(48+index)
		_dungeon_str += '\n'
	#print(_dungeon_str)
	
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
		cell[3] = filtered_edges
		room_graph[cell[0]] = cell
	
	print('\n\ndungeon step 2 - graph')
	#print(room_graph.keys())
	_dungeon_str = ''
	basic_grid = []
	for j in range(0, _height):
		basic_grid.push_back([])
		for i in range(0, _width):
			basic_grid[j].push_back(' ')

	for key in room_graph.keys():
		var cell = room_graph[key]
		for i in range(cell[1], cell[1] + cell[4]):
			for j in range(cell[2], cell[2] + cell[5]):
				basic_grid[j][i] = '%s' % char(48 + cell[0])
	
	for j in range(0, _height):
		for i in range(0, _width):
			_dungeon_str += '%s' % basic_grid[j][i]
		_dungeon_str += '\n'
	print(_dungeon_str)
	# step 3 merge nodes
	var _select_room_chance = 0.4
	var _merge_room_chance = 0.2

	for key in room_graph.keys():
		var cell: Array = room_graph[key]
		if int(key) != cell[0]: continue
		if randf() > _select_room_chance: continue
		for _edge_index in cell[3]:
			if randf() > _merge_room_chance: continue
			#print('embed cell[%d] into cell[%d]' % [_edge_index, cell[0]])
			embed_nodes(room_graph, cell[0], _edge_index)


	print('\n\ndungeon step 3')
	_dungeon_str = ''
	basic_grid = []
	for j in range(0, _height):
		basic_grid.push_back([])
		for i in range(0, _width):
			basic_grid[j].push_back(' ')

	for key in room_graph.keys():
		var cell = room_graph[key]
		for i in range(cell[1], cell[1] + cell[4]):
			for j in range(cell[2], cell[2] + cell[5]):
				basic_grid[j][i] = '%s' % char(48 + cell[0])
	
	for j in range(0, _height):
		for i in range(0, _width):
			_dungeon_str += '%s' % basic_grid[j][i]
		_dungeon_str += '\n'
	print(_dungeon_str)
	
	for key in room_graph.keys():
		var cell = room_graph[key]
		if cell[0] != int(key): continue
		var _btn = Button.new()
		_btn.text = '%s' % char(48 + cell[0])
		_btn.connect("button_down", self, '_load_node', [room_graph, key])
		buttons.add_child(_btn)
	
	# colored dungeon
	var total = buttons.get_child_count()
	index = 0
	var colors = {}
	for key in room_graph.keys():
		var cell = room_graph[key]
		if cell[0] != int(key): continue
		var color = Color.from_hsv(index/total, 0.67, 0.9)
		index += 1.0
		colors['%s' % char(48 + key)] = color
	_dungeon_str = ''
	for j in range(0, _height):
		for i in range(0, _width):
			var key = basic_grid[j][i]
			_dungeon_str += '[color=#%s]O[/color]' % [colors[key].to_html(false)]
		_dungeon_str += '\n'
	$Control/RichTextLabel.bbcode_text = _dungeon_str



func embed_nodes(room_graph, parent_index, child_index, check_parent=true):
	var parent = room_graph[parent_index]
	var child_room = room_graph[child_index]
	if check_parent and child_room[0] != child_index:
		embed_nodes(room_graph, parent_index, child_room[0])
	if child_room[6].size() > 0:
		for child in child_room[6]:
			embed_nodes(room_graph, parent_index, child, false) # reparent
		child_room[6] = []
	child_room[0] = parent[0]
	parent[3].erase(child_index)
	child_room[3].erase(parent[0])
	parent[6].push_back(child_index)


func _load_node(room_graph, key):
	$Control/RichTextLabel.text = str(room_graph[key])
