tool
extends Prop

export(Array, String, MULTILINE) var pages = []
export var background: Texture = null


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$Compartiment.connect('visibility_changed', self, '_update_description')
	
	if Globals.state.get('Penthouse-COMPARTIMENT_OPENED'):
		$Compartiment.show()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	# TODO: This should show the panel popup, and once successfully solved, call
	#		the _show_interior function.
	if Globals.state.get('Penthouse-COMPARTIMENT_OPENED'):
		yield(E.run([
			C.walk_to_clicked(),
			'Player: Oh my...',
			'...',
			'Player: A dead body',
			'Player: And a trophy filled with blood',
			'...',
			'Player: What is this?'
		]), 'completed')
		
		G.show_documents({pages = pages, bg = background})
		yield(G, 'documents_closed')
		
		yield(E.run([
			'...',
			'Player: What a miserable way to die',
			'...',
			'Player: Wait, it is holding an USB',
			'Player: Might be the one mentioned in the notes',
			I.add_item('RegistryUsb'),
			"Player: Now I'll be able to see the registry of the building!"
		]), 'completed')
	else:
		yield(E.run([
			C.walk_to_clicked(),
			'Player: What is this for?',
		]), 'completed')
		
		room.show_panel()
#		Globals.set_state('Penthouse-COMPARTIMENT_OPENED', true)


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass

func _on_reveal():
	$Sprite.region_rect.size.y = 0
	self.show()
	
	yield(get_tree().create_timer(0.3), 'timeout')
	
	$Tween.interpolate_property(
		$Sprite, 'region_rect:size:y',
		0, 45,
		2.6, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,
		0.5
	)
	$Tween.start()
	
	yield(E.run([
		E.wait(0.5),
		A.play({cue_name = 'sfx_secret_door_open2'}),
		E.wait(2.6),
		'Player: Another secret compartiment?',
	]), 'completed')


func _show_interior() -> void:
	# TODO: Use an animation for this
	yield(get_tree().create_timer(1.0), 'timeout')
	$Compartiment.show()


func _update_description() -> void:
	if $Compartiment.visible:
		description = 'Carcass and trophy'
