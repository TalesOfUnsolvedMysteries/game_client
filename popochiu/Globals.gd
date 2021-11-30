extends Node
# Clase de uso transversal para todos los objetos del proyecto. Aquí se puede
# guardar información que se usará en varias habitaciones, o cosas relacionadas
# con el estado del juego.

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


var main_mx_play = false

var bug_name := ''
var bug_adn := ''
sync var state := {}
var server_file = "user://server.save"


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
