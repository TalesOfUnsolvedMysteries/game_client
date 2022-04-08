tool
extends PopochiuRoom


onready var shelfs = [find_node('Shelf1'), find_node('Shelf2'), find_node('Shelf3'), find_node('Shelf4')]
onready var vases = [find_node('Vase1'), find_node('Vase2'), find_node('Vase3'), find_node('Vase4')]

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta
func _ready():
	var index = 0
	for shelf in shelfs:
		var vase = vases[index]
		shelf.connect('vase_placed', vase, 'set_vase')
		shelf.connect('vase_placed', self, '_on_weight_updated')
		vase.connect('vase_removed', self, '_on_weight_updated')
		index += 1

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	pass


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
func _on_weight_updated (vase_name):
	for shelf in shelfs: shelf.evaluate()
