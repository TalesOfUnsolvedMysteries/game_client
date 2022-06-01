extends Node
# Clase de uso transversal para todos los objetos del proyecto. Aquí se puede
# guardar información que se usará en varias habitaciones, o cosas relacionadas
# con el estado del juego.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

const SERVER_IP = '127.0.0.1'
const SERVER = 'http://%s:3000/' % SERVER_IP

enum TestMode {
	SINGLE,			# single player
	SERVER_PILOT,	# connected to game server
	NODE_SERVER,	# connected to http game server
	BLOCKCHAIN		# connection includes blockchain
}

export var test_mode = TestMode.SINGLE

signal battery_charge_updated
signal shelf_weights_updated

enum Bodies {
	BEETLE,
	LADYBUG,
	BEE
}

const HEADS := [
	preload('res://popochiu/Characters/Bug/parts/head_bee.png'),
	preload('res://popochiu/Characters/Bug/parts/head_beetle.png'),
	preload('res://popochiu/Characters/Bug/parts/head_ladybird.png'),
	preload('res://popochiu/Characters/Bug/parts/head_ant.png'),
	preload('res://popochiu/Characters/Bug/parts/head_ghost.png'),
]
const BODIES := [
	preload('res://popochiu/Characters/Bug/parts/body_bee.png'),
	preload('res://popochiu/Characters/Bug/parts/body_beetle.png'),
	preload('res://popochiu/Characters/Bug/parts/body_ladybird.png'),
	preload('res://popochiu/Characters/Bug/parts/body_ant.png'),
	preload('res://popochiu/Characters/Bug/parts/body_ghost.png'),
]
const LEGS := [
	preload('res://popochiu/Characters/Bug/parts/legs_bee.png'),
	preload('res://popochiu/Characters/Bug/parts/legs_beetle.png'),
	preload('res://popochiu/Characters/Bug/parts/legs_ladybird.png'),
	preload('res://popochiu/Characters/Bug/parts/legs_ant.png'),
]
const EYES := [
	'x',
	preload('res://popochiu/Characters/Bug/parts/eyes_square.png'),
	preload('res://popochiu/Characters/Bug/parts/eyes_oval.png'),
	preload('res://popochiu/Characters/Bug/parts/eyes_circle.png'),
	preload('res://popochiu/Characters/Bug/parts/eyes_sunglasses.png'),
]
const ARMS := [
	'x',
	preload('res://popochiu/Characters/Bug/parts/arms_strong.png'),
	preload('res://popochiu/Characters/Bug/parts/arms_pointy.png'),
	preload('res://popochiu/Characters/Bug/parts/arms_thin.png'),
	preload('res://popochiu/Characters/Bug/parts/arms_sexy.png'),
]
const SHOES := [
	'x',
	preload('res://popochiu/Characters/Bug/parts/shoes_converse.png'),
	preload('res://popochiu/Characters/Bug/parts/shoes_boots.png'),
	preload('res://popochiu/Characters/Bug/parts/shoes_sandals.png'),
	preload('res://popochiu/Characters/Bug/parts/shoes_gogo.png'),
]
const BATTERY_CHARGING_TIME := 0.1 * 60
const NFTs := {
	ENGINE_ROOM = {
		label = 'Engine keeper',
		img = 'nft_engine_room',
		id = '0001'
	},
	NEW_FLOORS = {
		label = 'New floors +',
		img = 'nft_new_floors',
		id = '0002'
	},
	UNLOCK_ROOM_102 = {
		label = 'Unlock Room 102',
		img = 'nft_new_floors',
		id = '0003'
	},
	UNLOCK_ROOM_201 = {
		label = 'Unlock Room 201',
		img = 'nft_new_floors',
		id = '0004'
	},
	UNLOCK_ROOM_202 = {
		label = 'Unlock Room 202',
		img = 'nft_new_floors',
		id = '0005'
	},
	UNLOCK_ROOM_301 = {
		label = 'Unlock Room 301',
		img = 'nft_new_floors',
		id = '0006'
	},
	UNLOCK_ROOM_302 = {
		label = 'Unlock Room 302',
		img = 'nft_new_floors',
		id = '0007'
	},
	ELEVATOR_TECHIE_1 = {
		label = 'Fix elevator program v1',
		img = 'nft_new_floors',
		id = '0008'
	},
	ELEVATOR_TECHIE_2 = {
		label = 'Fix elevator program v2',
		img = 'nft_new_floors',
		id = '0009'
	},
	MELODY_LOVER = {
		label = 'find the secret box in the jukebox',
		img = 'nft_new_floors',
		id = '0010'
	},
	VASE_LOCK = {
		label = 'open the secret compartiment on penthouse',
		img = 'nft_new_floors',
		id = '0011'
	},
	DETECTIVE = {
		label = 'solve the two steps puzzle on the secret penthouse\'s compartiment',
		img = 'nft_new_floors',
		id = '0012'
	},
	LOCKSMITH = {
		label = 'Unlocks the Engine Room fuse-box',
		img = 'nft_new_floors',
		id = '0013'
	},
	ELEVATOR_FIXED = {
		label = 'Fixes the elevator engine',
		img = 'nft_new_floors',
		id = '0014'
	},
	PUZZLE_AMATEUR = {
		label = 'Solves the Janitor\'s room puzzle',
		img = 'nft_new_floors',
		id = '0015'
	},
	SUMMON_101_SPIRIT = {
		label = 'Summons the spirit from 101 for the first time ',
		img = 'nft_new_floors',
		id = '0016'
	},
	SUMMON_102_SPIRIT = {
		label = 'Summons the spirit from 102 for the first time ',
		img = 'nft_new_floors',
		id = '0017'
	},
	SUMMON_201_SPIRIT = {
		label = 'Summons the spirit from 201 for the first time ',
		img = 'nft_new_floors',
		id = '0018'
	},
	SUMMON_202_SPIRIT = {
		label = 'Summons the spirit from 202 for the first time ',
		img = 'nft_new_floors',
		id = '0019'
	},
	SUMMON_301_SPIRIT = {
		label = 'Summons the spirit from 301 for the first time ',
		img = 'nft_new_floors',
		id = '0020'
	},
	SUMMON_302_SPIRIT = {
		label = 'Summons the spirit from 302 for the first time ',
		img = 'nft_new_floors',
		id = '0021'
	},
	SUMMON_PENTHOUSE_SPIRIT = {
		label = 'Summons the spirit from Penthouse for the first time ',
		img = 'nft_new_floors',
		id = '0022'
	}
}

var main_mx_play = false
var bug_name := ''
var bug_adn := ''
var turn := 0
sync var state := {
	'Lobby-PC_POWERED': false,
	'Lobby-USB_IN_PC': false,
	'PC_ELEVATOR_APP_VERSION': 1,
	'ELEVATOR_ENABLED': 0,
	'Lobby-ENGINE_ROOM_UNLOCKED': false,
	'EngineRoom-ELEVATOR_WORKING': false,
	'EngineRoom-CHARGING_BATTERY': false,
	'MasterKey-CONFIG': '0203',
	'FirstFloor-102_UNLOCKED': false,
	'SecondFloor-201_UNLOCKED': false,
	'SecondFloor-202_UNLOCKED': false,
	'ThirdFloor-301_UNLOCKED': false,
	'ThirdFloor-302_UNLOCKED': false,
	'Jukebox-Secret_Box_OPENED': false,
	# inventory object locations
	'Janitor-MASTER_KEY-in': true,
	'Janitor-KEY_ENGINE_ROOM-in': true,
	# elevator card locations
	'Tecnician-ELEVATOR_CARD_IN_LOCKER': true,
	'EngineRoom-MOTHERBOARD_WITH_CARD': false,
	'Lobby-ELEVATOR_CARD_IN_PC': false,
	'ELEVATOR_CARD_LAST_LOCATION': 'Tecnician-ELEVATOR_CARD_IN_LOCKER',
	# elevator battery locations
	'EngineRoom-MOTHERBOARD_WITH_BATTERY': true,
	'EngineRoom-CHARGE_SOCKET_WITH_BATTERY': false,
	'BATTERY_LAST_LOCATION': 'EngineRoom-MOTHERBOARD_WITH_BATTERY',
	# penthouse vases
	'Penthouse_VASES_ON_Shelfs': ['VaseBlue', 'VaseGreen', 'VaseYellow', 'VaseRed'],
	'Penthouse_WEIGHTS_ON_Shelfs': [1.6, 0.815, 1.25, 2.38124],
	'Penthouse-VASE_SOLVED': false,
	'Penthouse-COMPARTIMENT_OPENED': true,
	'Penthouse-FORTUNETELLER_NOTES': false,
	# ADN picker - Doctor items
	'ADN_picker_content': 'PENTHOUSE_CORPSE',
	# Fortune Teller
	'RITUAL_configuration': '000ABCDE000',
	'RITUAL_summoned': []
}
var server_file = "user://server.save"
var battery_power := 0.0 setget _set_battery_power
var elevator_used := false
# Mapeados por ID
sync var puzzle_state := {} setget _set_puzzle_state

var _battery_charging_elapsed := 0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	Console.add_command('set_state', self)\
		.set_description('Sets a global state')\
		.add_argument('key', TYPE_STRING)\
		.add_argument('value', TYPE_BOOL)\
		.register()
	
	Console.add_command('charge_battery', self, '_dev_charge_battery')\
		.set_description('Fully charges the battery for the elevator motherboard')\
		.register()
	
	Console.add_command('add_item', self, '_dev_add_item')\
		.set_description('Adds an item to the inventory')\
		.add_argument('script_name', TYPE_STRING)\
		.register()
	
	Console.add_command('discard_item', self, '_dev_discard_item')\
		.set_description('Discards an item from the inventory')\
		.add_argument('script_name', TYPE_STRING)\
		.register()
	
	Console.add_command('win_nft', self, '_dev_win_nft')\
		.set_description('Makes the player win a NFT')\
		.add_argument('key', TYPE_STRING)\
		.register()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_state(key, value):
	state[key] = value

	if NetworkManager.server:
		sync_state()
		save_state()


func sync_state():
	if NetworkManager.server and NetworkManager.pilot_peer_id != -1:
		rset_id(NetworkManager.pilot_peer_id, 'state', state)
		rset_id(NetworkManager.pilot_peer_id, 'puzzle_state', puzzle_state)


func save_state ():
	if !NetworkManager.server: return
	var file = File.new()
	file.open(server_file, File.WRITE)
	file.store_var(state, true)
	file.store_var(puzzle_state, true)
	file.close()


func load_state ():
	if !NetworkManager.server: return
	var file = File.new()
	if file.file_exists(server_file):
		file.open(server_file, File.READ)
		state = file.get_var(true)
		puzzle_state = file.get_var(true)
		file.close()


# Establece la apariencia del PC en base a una cadena de códigos:
# HEAD BODY LEGS EYES ARMS SHOES
func set_appearance(adn: String) -> void:
	bug_adn = adn
	
	if is_instance_valid(C.player):
		C.player.load_appearance(adn)


func start_battery_charging() -> void:
	set_state('EngineRoom-CHARGING_BATTERY', true)
	add_battery_power()


# Aumenta en X la carga de la batería en la sala de motores (RoomEngineRoom)
func add_battery_power() -> void:
	yield(get_tree().create_timer(1.0), 'timeout')

	if not state.get('EngineRoom-CHARGING_BATTERY'): return
	
	_battery_charging_elapsed += 1
	self.battery_power = _battery_charging_elapsed * 100.0 / BATTERY_CHARGING_TIME


func stop_battery_charging() -> void:
	#_battery_charging_elapsed = 0
	#self.battery_power = 0
	set_state('EngineRoom-CHARGING_BATTERY', false)
	pass


func get_adn_textures(adn: String) -> Array:
	var textures := []
	
	for idx in adn.length():
		match idx:
			0:
				textures.append(HEADS[int(adn[idx])])
			1:
				textures.append(BODIES[int(adn[idx])])
			2:
				textures.append(LEGS[int(adn[idx])])
			3:
				if adn[idx] != 'x': textures.append(EYES[int(adn[idx])])
				else: textures.append(null)
			4:
				if adn[idx] != 'x': textures.append(ARMS[int(adn[idx])])
				else: textures.append(null)
			5:
				if adn[idx] != 'x': textures.append(SHOES[int(adn[idx])])
				else: textures.append(null)
	
	return textures


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _dev_charge_battery() -> void:
	self.battery_power = 100


func _dev_add_item(script_name: String) -> void:
	Utils.invoke(I, 'add_item', [script_name, false])

func _dev_discard_item(script_name: String) -> void:
	Utils.invoke(I, 'discard_item', [script_name, false])

func _dev_win_nft(id := '') -> void:
	if NFTs.has(id):
		G.emit_signal('nft_won', NFTs[id])
	else:
		G.emit_signal('nft_won', Utils.get_random_array_element(NFTs.values()))


func _set_battery_power(value: float) -> void:
	battery_power = value
	
	if battery_power == 0:
		set_state('EngineRoom-CHARGING_BATTERY', false)
		set_state('EngineRoom-MOTHERBOARD_BATTERY_FULL', false)
	else:
		emit_signal('battery_charge_updated')
	
		if battery_power < 100:
			add_battery_power()
		else:
			# Se cargó la batería
			set_state('EngineRoom-CHARGING_BATTERY', false)
			set_state('EngineRoom-MOTHERBOARD_BATTERY_FULL', true)


func _set_puzzle_state(value: Dictionary) -> void:
	puzzle_state = value
	
	if NetworkManager.server:
		save_state()


# helper for vases
func set_vase_on_shelf(index, vasel_name, weight):
	var weights = state.get('Penthouse_WEIGHTS_ON_Shelfs')
	weights[index] = weight
	set_state('Penthouse_WEIGHTS_ON_Shelfs', weights)
	var shelfs = state.get('Penthouse_VASES_ON_Shelfs')
	shelfs[index] = vasel_name
	set_state('Penthouse_VASES_ON_Shelfs', shelfs)
	A.play({cue_name = 'sfx_shelf_vase_move', is_in_queue = false })
	yield(get_tree().create_timer(0.1), 'timeout')
	emit_signal('shelf_weights_updated')
	yield(E.run([
		E.wait(0.45)
	]), 'completed')

# test modes validations

func is_single_test ():
	return test_mode == TestMode.SINGLE
