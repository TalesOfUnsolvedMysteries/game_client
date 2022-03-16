extends "res://popochiu/GraphicInterface/Popups/MasterKey/DoorSecret.gd"

onready var secret: Secret = find_node('Secret')

# should check server global state to validate if this action could be performed
func _validate_state():
	print('check if this player have the proper ADN: ', Globals.bug_adn)
	var correct = secret.solve(Globals.bug_adn)
	if !correct:
		print('should emit a die event')
	return correct

