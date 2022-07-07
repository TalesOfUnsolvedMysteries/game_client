tool
extends PopochiuRoom

var first_panel_solved = false

onready var shelfs = [
	find_node('Shelf1'),
	find_node('Shelf2'),
	find_node('Shelf3'),
	find_node('Shelf4')
]
onready var secret = find_node('Secret')
onready var secret_hole = find_node('VaseHole')
onready var secret_compartiment = find_node('SecretCompartiment')
onready var second_panel: Panel = $GraphicInterface/PenthousePanel
onready var magazine: PanelContainer = $GraphicInterface/MysteriesMagazine
onready var painting = $PaintingOverlay2D


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
# TODO: Sobrescribir los métodos de Godot que hagan falta
func _ready():
	I.connect('item_discarded', self, '_on_item_discarded')
	secret.connect('solved', self, '_on_solved')
	Globals.connect('shelf_weights_updated', self, '_on_weight_updated')
	secret_hole.connect('vase_puzzle_solved', self, '_on_vase_puzzle_solved')
	$MoveBlockOverlay.connect('solved', self, '_show_second_panel')
	G.connect('nft_shown', self, '_on_second_panel_solved')

	if Globals.state.get('Penthouse-VASE_SOLVED')\
	or Globals.state.get('Penthouse-COMPARTIMENT_OPENED'):
		secret_hole.set_solved()
		secret_compartiment.show()


func _enter_tree() -> void:
	if OS.has_feature('editor'):
		Console.add_command('open_hole', self, '_dev_open_hole').register()
		Console.add_command('open_secret', self, '_on_vase_puzzle_solved').register()
		Console.add_command('open_interior', self, '_dev_open_interior').register()
		Console.add_command('reset_puzzle', self, 'reset_two_puzzle').register()


func _exit_tree() -> void:
	if OS.has_feature('editor'):
		Console.remove_command('open_hole')
		Console.remove_command('open_secret')
		Console.remove_command('open_interior')
		Console.remove_command('reset_puzzle')
#		Console.remove_command('open_interior')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	C.player.face_left(false)


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_panel() -> void:
	if !first_panel_solved:
		$MoveBlockOverlay.appear()
	else:
		second_panel.appear()


func show_magazine() -> void:
	magazine.appear()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
# TODO: Poner aquí los métodos privados
func _on_item_discarded(item: InventoryItem):
	if !item.script_name.match('Vase*'): return
	for shelf in shelfs:
		if shelf.handle_discarded_vase(item):
			break

func _on_weight_updated():
	var vases = Globals.state.get('Penthouse_VASES_ON_Shelfs')
	var code = ''
	for vase in vases:
		code += '_' if vase == '' else vase[4]
	
	secret.solve(code)

func _on_solved(solved):
	if solved:
		secret_hole.on_reveal()
	else:
		secret_hole.on_hide()

func _on_vase_puzzle_solved():
	Globals.set_state('Penthouse-VASE_SOLVED', true)
	G.emit_signal('nft_won', Globals.NFTs['VASE_LOCK'])
	yield(G, 'nft_shown')
	secret_compartiment._on_reveal()


func _show_second_panel() -> void:
	first_panel_solved = true
	A.play({cue_name = 'sfx_motherboard_success', is_in_queue = false})
	yield($MoveBlockOverlay.on_solved(), 'completed')
	$MoveBlockOverlay.disappear()
	second_panel.appear(false)


func _dev_open_hole() -> void:
	_on_solved(true)

func _on_second_panel_solved() -> void:
	if Globals.state.get('Penthouse-COMPARTIMENT_OPENED'):
		second_panel.disappear()
		yield(E.run([E.wait(0.4)]), 'completed')
		secret_compartiment._show_interior()


func _dev_open_interior() -> void:
	Globals.set_state('Penthouse-VASE_SOLVED', true)
	Globals.set_state('Penthouse-COMPARTIMENT_OPENED', true)
	
	secret_hole.set_solved()
	secret_compartiment.show()
	secret_compartiment._show_interior()
