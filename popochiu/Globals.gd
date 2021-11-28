extends Node
# Clase de uso transversal para todos los objetos del proyecto. Aquí se puede
# guardar información que se usará en varias habitaciones, o cosas relacionadas
# con el estado del juego.

enum Bodies {
	BEETLE,
	LADYBUG,
	BEE
}

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
