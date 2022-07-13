extends Area2D

var texture: Texture setget set_texture

func _ready():
	connect('input_event', self, '_check_click')

func _check_click(_v: Node, e: InputEvent, _i: int) -> void:
	var mouse_event: = e as InputEventMouseButton
	if mouse_event and mouse_event.pressed:
		if mouse_event.button_index == BUTTON_LEFT:
			if I.active:
				Utils.invoke(self, 'on_item_used', [I.active])
			else:
				on_interact()
		if mouse_event.button_index == BUTTON_RIGHT:
			on_look()
		get_tree().set_input_as_handled()


func on_interact() -> void:
	pass

func on_look() -> void:
	pass


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MagicGlasses':
		get_parent().show_hidden(true)
		I.set_active_item(null, false)
	else:
		.on_item_used(item)

func set_texture(_texture: Texture):
	$Sprite.texture = _texture
	$CollisionPolygon2D.shape.extents.x = _texture.get_width() / 2
	$CollisionPolygon2D.shape.extents.y = _texture.get_height() / 2

