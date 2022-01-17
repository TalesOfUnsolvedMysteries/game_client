extends Node
# Clase de uso transversal para todos los objetos del proyecto. Aquí se puede
# guardar información que se usará en varias habitaciones, o cosas relacionadas
# con el estado del juego.

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
]
const BODIES := [
	preload('res://popochiu/Characters/Bug/parts/body_bee.png'),
	preload('res://popochiu/Characters/Bug/parts/body_beetle.png'),
	preload('res://popochiu/Characters/Bug/parts/body_ladybird.png'),
]
const LEGS := [
	preload('res://popochiu/Characters/Bug/parts/legs_bee.png'),
	preload('res://popochiu/Characters/Bug/parts/legs_beetle.png'),
	preload('res://popochiu/Characters/Bug/parts/legs_ladybird.png'),
]
const EYES := [
	preload('res://popochiu/Characters/Bug/parts/eyes_square.png'),
	preload('res://popochiu/Characters/Bug/parts/eyes_oval.png'),
	preload('res://popochiu/Characters/Bug/parts/eyes_circle.png'),
]
const CLOTHES := [
	preload('res://popochiu/Characters/Bug/parts/clothes_strong.png'),
	preload('res://popochiu/Characters/Bug/parts/clothes_pointy.png'),
	preload('res://popochiu/Characters/Bug/parts/clothes_thin.png'),
]
const SHOES := [
	preload('res://popochiu/Characters/Bug/parts/shoes_converse.png'),
	preload('res://popochiu/Characters/Bug/parts/shoes_boots.png'),
	preload('res://popochiu/Characters/Bug/parts/shoes_sandals.png'),
]
const BATTERY_CHARGING_TIME := 1 * 60

var main_mx_play = false
var bug_name := ''
var bug_adn := ''
sync var state := {}
var server_file = "user://server.save"
var battery_power := 0

var _battery_charging_elapsed := 0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	Console.add_command('set_state', self)\
		.set_description('Sets a global state')\
		.add_argument('key', TYPE_STRING)\
		.add_argument('value', TYPE_BOOL)\
		.register()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_state(key, value):
	state[key] = value
	if NetworkManager.server:
		save_state()


func sync_state():
	if NetworkManager.server:
		rset_id(NetworkManager.pilot_peer_id, 'state', state)


func save_state ():
	if !NetworkManager.server: return
	var file = File.new()
	file.open(server_file, File.WRITE)
	file.store_var(state, true)
	file.close()


func load_state ():
	if !NetworkManager.server: return
	var file = File.new()
	if file.file_exists(server_file):
		file.open(server_file, File.READ)
		state = file.get_var(true)
		file.close()


# Establece la apariencia del PC en base a una cadena de códigos:
# HEAD BODY LEGS EYES CLOTHES SHOES
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
	battery_power = _battery_charging_elapsed * 100 / BATTERY_CHARGING_TIME
	
	emit_signal('battery_charge_updated')
	
	if battery_power < 100:
		add_battery_power()
	else:
		set_state('EngineRoom-CHARGING_BATTERY', false)
		set_state('EngineRoom-MOTHERBOARD_BATTERY_FULL', true)


func stop_battery_charging() -> void:
	set_state('EngineRoom-CHARGING_BATTERY', false)
	
	_battery_charging_elapsed = 0
	battery_power = 0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _dev_charge_battery() -> void:
	pass
