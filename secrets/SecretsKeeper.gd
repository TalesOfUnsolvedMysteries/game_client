extends Node

const _filename = 'res://.secrets'

var env = {}

signal secret_retrieved

func _ready():
	_load_secrets()

func _load_secrets ():
	var file = File.new()
	if(!file.file_exists(_filename)):
		return {}
	
	file.open(_filename, File.READ)
	
	var line = ''
	
	while !file.eof_reached():
		line = file.get_line()
		var o = line.split('=')
		if(o.size() == 2):
			env[o[0]] = o[1].lstrip("\"").rstrip("\"")
	print(env)

func get(secret_key):
	if env.has(secret_key):
		return env[secret_key]
	return ''

func async_get(secret_key):
	yield(get_tree(), 'idle_frame')
	if !NetworkManager.server and !Globals.is_single_test(): return
	var secret = self.get(secret_key)
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'secret_request', secret)
	emit_signal('secret_retrieved', secret)

remote func secret_request(secret):
	if NetworkManager.isPilot():
		emit_signal('secret_retrieved', secret)
