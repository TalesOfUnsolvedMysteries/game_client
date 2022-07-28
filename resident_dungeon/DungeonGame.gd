extends Node


export(Resource) var dungeon = null
export(Resource) var player = null

var current_room: DungeonRoom = null

signal room_entered

func load_dungeon(_dungeon: Dungeon):
	dungeon = _dungeon

func load_player(_player: DungeonPlayer):
	player = _player

func start():
	return move_to_room(dungeon.root_node)

func move_to_room(room_key):
	current_room = dungeon.get_room(room_key)
	if current_room == null:
		print('the room %d is null' % room_key)
		return
	player.position = DungeonUtils.get_random_position_in_room(current_room)
	#var interactions = current_room.get_interactions()
	#print('moved to %s' % room_key)
	#print(interactions)
	#return interactions
	emit_signal('room_entered', current_room)

func open_door(door_key):
	var door: DungeonDoor = dungeon.doors[door_key]
	print(door_key, door.key)
	if door == null:
		print('the door (%s) is null!!' % door_key)
		return
	print('opening door %s' % door_key)
	var next_room_key = door.get_next_room(current_room.key)
	print('the next room is %d' % next_room_key)
	move_to_room(next_room_key)
