extends Node2D

export(Color) var color_room = Color('001f66')
export(Color) var color_current_room = Color.red
export(Color) var color_hidden_room = Color('292222')
export(Color) var color_border_room = Color('e9e9e9')
export(Color) var color_door = Color('f2e204')
export(Color) var color_locked_door = Color.red

var current_room = ''

func print_full_data_dungeon(dungeon, decoration_data):
	print_dungeon(dungeon, decoration_data)
	var str_matrix = ''
	for j in dungeon['adjacency_matrix'].size():
		for i in dungeon['adjacency_matrix'][j].size():
			str_matrix += str(dungeon['adjacency_matrix'][j][i])
		str_matrix += '\n'

func decorate_dungeon_graph(dungeon: Dungeon) -> Dictionary:
	var rooms = dungeon.rooms
	var node_keys:Array = rooms.keys()
	node_keys.shuffle()
	var codes:String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	var index = 1.0
	var decorated_rooms = {}
	for key in node_keys:
		var room = dungeon.get_room(key)
		var code_key = codes[(int(index))%(codes.length())]
		var color_key = Color.from_hsv(index/node_keys.size(), 0.67, 0.9)
		decorated_rooms[key] = {
			'label': '[color=#%s]%s[/color]' % [color_key.to_html(false), code_key],
			'color': color_key,
			'code_key': code_key
		}
		index += 1.0
	return decorated_rooms

func print_dungeon(dungeon: Dungeon, decoration_data):
	var rooms = dungeon.rooms
	var basic_grid = []
	var node_keys:Array = rooms.keys()
	var width = dungeon.configuration._width
	var height = dungeon.configuration._height

	for j in range(0, height):
		basic_grid.push_back([])
		for i in range(0, width):
			basic_grid[j].push_back(' ')
	
	# {'key': key, 'squares': [base_square], 'edges': filtered_edges}
	for key in node_keys:
		var room = rooms[key]
		for square in room.squares:
			for i in range(square.position.x, square.end.x):
				for j in range(square.position.y, square.end.y):
					basic_grid[j][i] = key
	
	var _dungeon_str = ''
	for j in range(0, height):
		for i in range(0, width):
			var key = basic_grid[j][i]
			_dungeon_str += decoration_data[key].label
		_dungeon_str += '\n'
	$RichTextLabel.bbcode_text = '[code]%s[/code]' % _dungeon_str
	draw_dungeon(dungeon, decoration_data)

func draw_dungeon(dungeon, decoration_data):
	for child in $Canvas.get_children():
		$Canvas.remove_child(child)
		child.queue_free()
	var cell_size = 7.0
	var rooms = dungeon.rooms
	var basic_grid = []
	var node_keys:Array = rooms.keys()
	# draw rooms
	for key in node_keys:
		var room: DungeonRoom = dungeon.get_room(key)
		var style = decoration_data[key]
		var border := Line2D.new()
		var shape := Polygon2D.new()
		#poly.invert_enable = true
		#poly.polygon = room.polygon
		var polygon = PoolVector2Array()
		polygon = room.polygon
		polygon.push_back(room.polygon[0])
		border.points = polygon
		border.z_index += 1
		border.joint_mode =Line2D.LINE_JOINT_ROUND
		border.begin_cap_mode = Line2D.LINE_CAP_ROUND
		border.end_cap_mode = Line2D.LINE_CAP_ROUND
		border.width = 0.8/cell_size
		border.scale = Vector2(cell_size, cell_size)
		shape.polygon = room.polygon
		shape.color = color_room
		shape.scale = Vector2(cell_size, cell_size)
		if room.type == DungeonRoom.Types.START:
			shape.color = color_current_room
		elif room.type == DungeonRoom.Types.LEAF:
			shape.z_index +=1
			shape.color = Color.green.darkened(0.5)
		elif room.type == DungeonRoom.Types.EXIT:
			shape.z_index +=1
			shape.color = Color.blue
		elif room.type == DungeonRoom.Types.END:
			shape.z_index +=1
			shape.color = Color.blue.lightened(0.5)
		elif room.type == DungeonRoom.Types.BOSS:
			shape.z_index +=1
			shape.color = Color.crimson
		elif room.type == DungeonRoom.Types.LOOT:
			shape.z_index +=1
			shape.color = Color.gold
		elif room.type == DungeonRoom.Types.SPECIAL_ITEM:
			shape.color = Color.deeppink
		elif room.type == DungeonRoom.Types.TERMINAL:
			shape.color = Color.darkcyan
		elif room.type == DungeonRoom.Types.SAFE:
			shape.color = Color.darkseagreen
		elif room.type == DungeonRoom.Types.SURVIVOR:
			shape.color = Color.aquamarine
		elif room.type == DungeonRoom.Types.KEY:
			shape.color = Color.wheat
		elif room.type == DungeonRoom.Types.DARK:
			shape.color = Color.black
		elif randf() > 0.6:
			
			#border.visible = true
			#shape.color = color_hidden_room
			#shape.z_index += 1
			pass
		#shape.color.a = 0.9
		border.default_color = color_border_room
		shape.name = 'ROOM-%d' % [key]
		$Canvas.add_child(shape)
		$Canvas.add_child(border)
	# draw doors
	for door_key in dungeon.doors.keys():
		var door: DungeonDoor = dungeon.doors.get(door_key)
		var line := Line2D.new()
		var w = 0 if door.vertical else 0.5
		var h = 0.5 if door.vertical else 0
		line.points = PoolVector2Array([
			Vector2(door.position.x + 0.5 + (w*-0.5), door.position.y + 0.5 + (h*-0.5)),
			Vector2(door.position.x + 0.5 + (w*0.5), door.position.y + 0.5 + (h*0.5))
		])
		line.scale = Vector2(cell_size, cell_size)
		line.default_color = color_door
		if door.lock_type == DungeonDoor.LOCK_TYPE.KEY:
			line.default_color = Color.rebeccapurple
		if door.lock_type == DungeonDoor.LOCK_TYPE.SIDE:
			line.default_color = Color.darkgray
		if randf() > 0.6:
			#line.default_color = color_locked_door
			pass
		if not door.enabled:
			line.default_color.a = 0.3
		line.width = 2.0/cell_size
		line.z_index += 1
		line.name = 'DOOR-%s' % door_key
		$Canvas.add_child(line)


func polygon_transform (room: DungeonRoom) -> PoolVector2Array:
	var polygon = PoolVector2Array()
	var position := Vector2(INF, INF)
	var size := Vector2(0, 0)
	var grid = []
	# calculate grid rect
	for square in room.squares:
		if square.position.x < position.x: position.x = square.position.x
		if square.position.y < position.y: position.y = square.position.y
		if square.end.x > size.x: size.x = square.end.x
		if square.end.y > size.y: size.y = square.end.y
	
	# fill polygon shape in grid rect
	for j in range(position.y, size.y):
		var row = []
		for i in range(position.x, size.x):
			if room.contains_point(Vector2(i, j)):
				row.push_back(1)
			else:
				row.push_back(0)
		grid.push_back(row)
	
	# choose starting point
	var j = 0
	var i = grid[j].find(1)
	var _index = i
	var visited = [_index]
	var scan_vector = Vector2(1, 0)
	polygon.push_back(Vector2(-0.5 + i, 0.5))
	polygon.push_back(Vector2(-0.5 + i, -0.5))
	var grid_container = Rect2(Vector2(0, 0), size - position)
	print(grid)
	
	while polygon[0] != polygon[-1]:
		yield(get_tree(), "idle_frame")
		print('i: ', polygon)
		var last_point = polygon[-1]
		scan_vector = scan_vector.rotated(-PI / 2)
		var next_cell = Vector2(i+scan_vector.x, j+scan_vector.y)
		var coord = transform_cell(next_cell, scan_vector)
		_index = round(next_cell.y*grid_container.end.x + next_cell.x)
		print('\ni1: ', coord)
		print('- ', _index)
		print('- ', next_cell)
		if grid_container.has_point(next_cell) and grid[next_cell.y][next_cell.x] == 1 and visited.find(_index) == -1:
			if coord == polygon[0]: break
			polygon.push_back(coord)
			visited.push_front(_index)
			i = next_cell.x
			j = next_cell.y
			continue
		
		# second rotation
		scan_vector = scan_vector.rotated(PI / 2)
		next_cell = Vector2(i+scan_vector.x, j+scan_vector.y)
		coord = transform_cell(next_cell, scan_vector)
		print('i2: ', coord)
		_index = round(next_cell.y*grid_container.end.x + next_cell.x)
		if coord == polygon[0]: break
		polygon.push_back(coord)
		if grid_container.has_point(next_cell) and grid[next_cell.y][next_cell.x] == 1 and visited.find(_index) == -1:
			visited.push_front(_index)
			i = next_cell.x
			j = next_cell.y
			continue
		
		# third rotation
		scan_vector = scan_vector.rotated(PI / 2)
		next_cell = Vector2(i+scan_vector.x, j+scan_vector.y)
		coord = transform_cell(next_cell, scan_vector)
		print('i3: ', coord)
		_index = round(next_cell.y*grid_container.end.x + next_cell.x)
		if coord == polygon[0]: break
		polygon.push_back(coord)
		if grid_container.has_point(next_cell) and grid[next_cell.y][next_cell.x] == 1 and visited.find(_index) == -1:
			visited.push_front(_index)
			i = next_cell.x
			j = next_cell.y
			continue
		
		# fourth rotation - returned to the last index
		scan_vector = scan_vector.rotated(PI / 2)
		next_cell = Vector2(i+scan_vector.x, j+scan_vector.y)
		coord = transform_cell(next_cell, scan_vector)
		print('i4: ', coord)
		_index = round(next_cell.y*grid_container.end.x + next_cell.x)
		if coord == polygon[0]: break
		polygon.push_back(coord)
		visited.push_front(_index)
		i = next_cell.x
		j = next_cell.y


	return polygon


func transform_cell(cell: Vector2, direction: Vector2):
	return Vector2(cell.x + direction.x*-0.5 + direction.y*0.5, cell.y + direction.x*-0.5 + direction.y*-0.5)

func from_coord_to_cell(position: Vector2, direction: Vector2):
	var rel_pos = Vector2(position.x-int(position.x), position.y-int(position.y))
	return position + Vector2(rel_pos.x*direction.x - rel_pos.y*direction.y, rel_pos.x*direction.x + rel_pos.y*direction.y)
	

func on_room_entered(room):
	print('on room entered dungeon decorator')
	print(room)
	if not current_room.empty():
		$Canvas.get_node(current_room).color = Color.blue
	current_room = 'ROOM-%d' % [room]
	print('current room ', current_room)
	var node = $Canvas.get_node(current_room)
	node.color = Color.red

