tool
extends PopochiuRoom

onready var shelfs = [find_node('Shelf1'), find_node('Shelf2'), find_node('Shelf3'), find_node('Shelf4')]
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta
func _ready():
	I.connect('item_discarded', self, '_on_item_discarded')

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	pass


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
func _on_item_discarded(item: InventoryItem):
	print(item.script_name)
	if !item.script_name.match('Vase*'): return
	for shelf in shelfs:
		if shelf.handle_discarded_vase(item):
			break
