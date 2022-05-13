tool
extends Prop

export var weight_index = 0

export var current_vase = 'VaseYellow'
export var location_name = 'yellowVasePoint'

var vase_textures = {
	'VaseYellow': load('res://popochiu/Rooms/Penthouse/Props/VaseYellow/vase_yellow.png'),
	'VaseRed': load('res://popochiu/Rooms/Penthouse/Props/VaseRed/vase_red.png'),
	'VaseGreen': load('res://popochiu/Rooms/Penthouse/Props/VaseGreen/vase_green.png'),
	'VaseBlue': load('res://popochiu/Rooms/Penthouse/Props/VaseBlue/vase_blue.png')
}

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	var shelfs = Globals.state.get('Penthouse_VASES_ON_Shelfs')
	set_vase(shelfs[weight_index])


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if Globals.state.get('Penthouse-VASE_SOLVED'): return
	yield(E.run([
		C.player_walk_to(room.get_point(location_name), true),
		E.wait(0.1),
		I.add_item(current_vase)
	]), 'completed')

	# checks the vase was added to the inventory
	if I.is_item_in_inventory(current_vase):
		yield(E.run([
			A.play({
				cue_name = 'sfx_pick_vase',
				is_in_queue = true
			}),
			E.wait(0.1)
		]), 'completed')
		Globals.set_vase_on_shelf(weight_index, '', 0)
		current_vase = ''
		self.description = 'Shelf'
		$Sprite.hide()


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A %s with some kind of symbol.' % [description.to_lower()]
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if Globals.state.get('Penthouse-VASE_SOLVED'): return
	if current_vase != '': return
	if !item.script_name.match('Vase*'):
		print('not a valid item')
		return
	yield(E.run([
		C.player_walk_to(room.get_point(location_name), true),
		E.wait(0.1),
		I.remove_item(item.script_name, false),
		A.play({
			cue_name = 'sfx_place_vase',
			is_in_queue = true
		}),
		E.wait(0.1)
	]), 'completed')
	Globals.set_vase_on_shelf(weight_index, item.script_name, item.weight)
	set_vase(item.script_name)


func add_discarded_vase(item: InventoryItem) -> void:
	yield(E.run([
		C.player_walk_to(room.get_point(location_name), true),
	]), 'completed')
	Globals.set_vase_on_shelf(weight_index, item.script_name, item.weight)
	set_vase(item.script_name)


func set_vase(vase_name):
	current_vase = vase_name
	if current_vase == '':
		$Sprite.hide()
	else:
		self.texture = vase_textures[current_vase]
		
		var capitalized: Array = current_vase.capitalize().split(' ')
		self.description = '%s %s' % [
			capitalized[1], capitalized[0].to_lower()
		]
		$Sprite.show()
