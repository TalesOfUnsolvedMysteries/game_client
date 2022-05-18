extends TextureRect

signal parts_shown

var target_widths := []

func _ready() -> void:
	modulate.a = 0.0
	
	for c in get_children():
		if c is Tween: continue
		
		target_widths.append((c.texture as AtlasTexture).region.size.x)
		
		(c.texture as AtlasTexture).region.size.x = 0.0
		c.get_child(0).hide()
		c.get_child(1).hide()


func appear(adn: String) -> void:
	modulate.a = 1.0
	
	var textures: Array = Globals.get_adn_textures(adn)
	
	for c in get_children():
		if c is Tween: continue
		
		if textures[c.get_index() - 1]:
			(c.get_child(1) as TextureRect).texture = textures[c.get_index() - 1]
		else:
			continue
		
		c.get_child(1).show()
		yield(get_tree().create_timer(0.3), 'timeout')
		
		$Tween.interpolate_property(
			c.texture, 'region:size:x',
			0.0, target_widths[c.get_index() - 1],
			0.5
		)
		$Tween.start()
		yield($Tween, 'tween_all_completed')
		
		c.get_child(0).show()
		yield(get_tree().create_timer(0.5), 'timeout')
	
	emit_signal('parts_shown')
