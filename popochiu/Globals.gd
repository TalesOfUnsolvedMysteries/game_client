extends Node
# Clase de uso transversal para todos los objetos del proyecto. Aquí se puede
# guardar información que se usará en varias habitaciones, o cosas relacionadas
# con el estado del juego.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

signal battery_charge_updated

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
]
const BODIES := [
	preload('res://popochiu/Characters/Bug/parts/body_bee.png'),
	preload('res://popochiu/Characters/Bug/parts/body_beetle.png'),
	preload('res://popochiu/Characters/Bug/parts/body_ladybird.png'),
	preload('res://popochiu/Characters/Bug/parts/body_ant.png'),
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
const BATTERY_CHARGING_TIME := 30 * 60
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
}

var main_mx_play = false
var bug_name := ''
var bug_adn := ''
var turn := 0
sync var state := {
#	'Lobby-PC_POWERED': true,
#	'EngineRoom-ELEVATOR_WORKING': true,
#	'SecondFloor-201_UNLOCKED': true,
#	'SecondFloor-202_UNLOCKED': true,
#	'ThirdFloor-301_UNLOCKED': true,
#	'ThirdFloor-302_UNLOCKED': true,
}
var server_file = "user://server.save"
var battery_power := 0 setget _set_battery_power
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
	
	Console.add_command('win_nft', self, '_dev_win_nft')\
		.set_description('Makes the player win a NFT')\
		.add_argument('key', TYPE_STRING)\
		.register()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_state(key, value):
	state[key] = value
	if NetworkManager.server:
		save_state()


func sync_state():
	if NetworkManager.server:
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
	self.battery_power = _battery_charging_elapsed * 100 / BATTERY_CHARGING_TIME


func stop_battery_charging() -> void:
	_battery_charging_elapsed = 0
	self.battery_power = 0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _dev_charge_battery() -> void:
	self.battery_power = 100


func _dev_add_item(script_name: String) -> void:
	I.add_item(script_name, false)


func _dev_win_nft(id := '') -> void:
	if NFTs.has(id):
		G.emit_signal('nft_won', NFTs[id])
	else:
		G.emit_signal('nft_won', Utils.get_random_array_element(NFTs.values()))


func _set_battery_power(value: int) -> void:
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
