extends Button

onready var lights = find_node('FloorsList')

func _ready():
	pass
	
func set_lights(switch):
	for j in range(0, 9):
		var active = (int(switch) & int(pow(2, j))) > 0
		print(active)
		if active:
			lights.get_child(8 - j).modulate = Color('ffffff')
		else:
			lights.get_child(8 - j).modulate = Color('141532')


func _toggled(pressed):
	if pressed:
		modulate = Color('ffffff')
	else:
		modulate = Color('2f4882')
