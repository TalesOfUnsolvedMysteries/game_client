tool
extends Prop

const ADNAnalyzer :=\
preload('res://popochiu/GraphicInterface/Popups/ADNAnalyzer/ADNAnalyzer.gd')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$ADNPicker.frame = 0 if Globals.state.get('ADN_picker_content', '').empty() else 1
	if I.is_item_in_inventory('ADNpicker'):
		$ADNPicker.hide()
	I.connect('item_discarded', self, '_on_item_discarded')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if I.is_item_in_inventory('ADNpicker'):
		yield(E.run([
			C.walk_to_clicked(),
			C.face_clicked(),
			'Player: Now what?'
		]), 'completed')
		
		room.turn_on_analyzer()
	else:
		yield(E.run([
			C.walk_to_clicked(),
			C.face_clicked(),
			"Player: I'll take the ADN picker with me.",
			E.runnable($ADNPicker, 'hide'),
			I.add_item('ADNpicker'),
		]), 'completed')


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	yield(E.run([
#		C.player_walk_to(room.get_point('stand_pc'), true),
		C.walk_to_clicked(),
		C.face_clicked()
	]), 'completed')
	
	if not item.script_name == 'ADNpicker':
		E.run(['Player: No can do.'])
		return
	
	var adn_sample: String = Globals.state.get('ADN_picker_content')
	
	if adn_sample.empty():
		yield(E.run([
			"Player: I'll put the ADN picker back in the thing.",
			I.remove_item('ADNpicker'),
			E.runnable($ADNPicker, 'show'),
			E.runnable($ADNPicker, 'set_frame', [0]),
			E.runnable($Sprite, 'set_frame', [0]),
			'...'
		]), 'completed')
	else:
		yield(E.run([
			'Player: I will put the ADN sample in the thing.',
			I.remove_item('ADNpicker'),
			E.runnable($ADNPicker, 'show'),
			E.runnable($ADNPicker, 'set_frame', [1]),
			E.runnable($Sprite, 'set_frame', [1]),
			'...'
		]), 'completed')
	
	room.turn_on_analyzer(adn_sample)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func on_analyzer_closed(state: String) -> void:
	$ADNPicker.frame = 0
	$Sprite.frame = 0
	
	match state:
		ADNAnalyzer.STATES.no_sample:
			E.run([
				'Player: Looks like I have to take a sample with the picker.'
			])
		ADNAnalyzer.STATES.no_picker:
			E.run([
				'Player: Looks like I have to put the picker in the thing.'
			])


func _on_item_discarded(item: InventoryItem):
	if item.script_name.match('ADNpicker'):
		$ADNPicker.show()
