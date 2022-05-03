extends "res://popochiu/GraphicInterface/Popups/MasterKey/DoorSecret.gd"

onready var secret: Secret = find_node('Secret')

signal wrong_adn_entered

# should check server global state to validate if this action could be performed
func _validate_state():
	print('check if this player have the proper ADN: ', Globals.bug_adn)
	var correct = secret.solve(Globals.bug_adn)
	if !correct:
		emit_signal('wrong_adn_entered')
		if !Globals.is_single_test():
			rpc_id(NetworkManager.pilot_peer_id, 'wrong_adn')
	return correct

remote func wrong_adn():
	if NetworkManager.isPilot():
		emit_signal('wrong_adn_entered')

func _on_incorrect_combination(): pass
