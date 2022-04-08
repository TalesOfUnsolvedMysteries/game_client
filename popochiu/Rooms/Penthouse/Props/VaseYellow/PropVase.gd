tool
extends Prop

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

	# checks the vase was added to the inventory
	if I.is_item_in_inventory(current_vase):
		Globals.set_weight_on_shelf(weight_index, 0)
		current_vase = ''
		self.description = 'Shelf'
		$Sprite.hide()

func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if current_vase != '': return
	if !item.script_name.match('Vase*'):
		print('not a valid item')
		return
	yield(E.run([
		C.walk_to_clicked(),
		I.remove_item(item.script_name, false)
	]), 'completed')
	Globals.set_weight_on_shelf(weight_index, item.weight)
	set_vase(item.script_name)

func set_vase(vase_name):
	current_vase = vase_name
	print('placed ', current_vase)
	self.texture = vase_textures[current_vase]
	self.description = current_vase
	$Sprite.show()
