extends Node

export(Resource) var dungeon_config setget _set_dungeon_config

signal dungeon_changed


func chance_merge(dungeon: Dungeon):
	var keys = dungeon.rooms.keys()
	var _select_room_chance = dungeon.configuration._select_room_chance
	var _merge_room_chance = dungeon.configuration._merge_room_chance
	var _min_number_rooms = dungeon.configuration._min_number_rooms
	
	for key in keys:
		if not dungeon.rooms.has(key): continue
		if randf() > _select_room_chance: continue
		var room = dungeon.rooms[key]
		for edge in room.edges:
			if randf() > _merge_room_chance: continue
			DungeonUtils.merge_rooms(dungeon, key, edge)
			if dungeon.rooms.size() <= _min_number_rooms:
				return


func random_merge_step(dungeon: Dungeon):
	var keys = dungeon.rooms.keys()
	var key = keys[randi()%keys.size()]
	var room: DungeonRoom = dungeon.get_room(key)
	var edges = room.edges
	if edges.size() == 0: return
	var edge = edges[randi()%edges.size()]
	DungeonUtils.merge_rooms(dungeon, key, edge)


func generate_dungeon():
	# build basic grid based dungeon 
	var dungeon = $GridGenerator.generate(dungeon_config)
	if not dungeon_config._random_merge:
		chance_merge(dungeon)
	var room_overflow = dungeon.rooms.size() - dungeon_config._max_number_rooms
	if room_overflow > 0:
		for i in range(0, room_overflow):
			random_merge_step(dungeon)
	var original_adjacency_matrix = dungeon.adjacency_matrix.duplicate(true)
	var result_adjacency_matrix = $GraphGenerator.build_tree(dungeon)
	dungeon.adjacency_matrix = result_adjacency_matrix
	$LevelDesigner.setup_level(dungeon, original_adjacency_matrix)
	emit_signal('dungeon_changed', dungeon)
	return dungeon


func generate_base_dungeon():
	return $GridGenerator.generate(dungeon_config)


func _set_dungeon_config(_new_config):
	if dungeon_config:
		dungeon_config.disconnect('changed', self, 'generate_dungeon')
	dungeon_config = _new_config
	dungeon_config.connect('changed', self, 'generate_dungeon')
	print('signal connected?')

