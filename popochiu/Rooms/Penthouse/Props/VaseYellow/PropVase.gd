tool
extends Prop

signal vase_removed
export var weight_index = 0

export var current_vase = 'VaseYellow'

var vase_textures = {
	'VaseYellow': load('res://popochiu/Rooms/Penthouse/Props/VaseYellow/vase_yellow.png'),
	'VaseRed': load('res://popochiu/Rooms/Penthouse/Props/VaseRed/vase_red.png'),
	'VaseGreen': load('res://popochiu/Rooms/Penthouse/Props/VaseGreen/vase_green.png'),
	'VaseBlue': load('res://popochiu/Rooms/Penthouse/Props/VaseBlue/vase_blue.png')
}

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		I.add_item(current_vase)
	]), 'completed')
	var weights = Globals.state.get('Penthouse_WEIGHTS_ON_Shelfs')
	weights[weight_index] = 0
	Globals.set('Penthouse_WEIGHTS_ON_Shelfs', weights)
	emit_signal('vase_removed', current_vase)
	current_vase = ''
	hide()

func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	print('again?', item.script_name)
	pass

func set_vase(vase_name):
	current_vase = vase_name
	print('placed ', current_vase)
	self.texture = vase_textures[current_vase]
	show()
