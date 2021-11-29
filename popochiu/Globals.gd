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
	prints(adn)
	if is_instance_valid(C.player):
		for idx in adn.length():
			match idx:
				0:
					C.player.set_head(HEADS[int(adn[idx])])
				1:
					C.player.set_body(BODIES[int(adn[idx])])
				2:
					C.player.set_legs(LEGS[int(adn[idx])])
				3,4,5:
					if adn[idx] != 'x':
						continue
				3:
					C.player.set_eyes(EYES[int(adn[idx])])
				4:
					C.player.set_clothes(CLOTHES[int(adn[idx])])
				5:
					C.player.set_shoes(SHOES[int(adn[idx])])
