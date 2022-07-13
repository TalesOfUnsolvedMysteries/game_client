class_name RemoteCall
extends Node

signal executed

var response

func _ready():
	pass # Replace with function body.

func execute(args:=[]):
	yield(get_tree(), 'idle_frame')
	if !NetworkManager.server and !Globals.is_single_test(): return
	yield(function_call(args), 'completed')
	emit_signal('executed')
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'remote_handler', response)

remote func remote_handler(_response):
	response = _response
	if NetworkManager.isPilot():
		emit_signal('executed', response)

func function_call(args:=[]):
	pass
