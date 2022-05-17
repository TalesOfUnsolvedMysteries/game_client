extends InventoryItem

export var empty: Texture = null
export var full: Texture = null

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	var content: String = Globals.state.get('ADN_picker_content')
	
	if content.empty():
		$Icon.texture = self.empty
	else:
		$Icon.texture = self.full
		

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
# Cuando se le hace clic en el inventario
func on_interact() -> void:
	.on_interact()
	# play a sound


# Lo que pasará cuando se haga clic derecho en el icono del inventario
func on_look() -> void:
	var content = Globals.state.get('ADN_picker_content')
	D.show_dialog('ADNpickerClean')


func _get_description() -> String:
	var content = Globals.state.get('ADN_picker_content')
	if I.active == self:
		return description
	if content.empty():
		return 'a device for extracting ADN (empty)'
	return 'a device with an ADN sample\n(right click to empty)'


# Lo que pasará cuando se use otro InventoryItem del inventario sobre este
func on_item_used(_item: InventoryItem) -> void:
	pass


func added_to_inventory() -> void:
	var content: String = Globals.state.get('ADN_picker_content')
	
	if content.empty():
		$Icon.texture = self.empty
	else:
		$Icon.texture = self.full


func on_discard () -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func take_sample(sample_source):
	Globals.set_state('ADN_picker_content', sample_source)
	$Icon.texture = self.full


func clean_sample():
	Globals.set_state('ADN_picker_content', '')
	$Icon.texture = self.empty

