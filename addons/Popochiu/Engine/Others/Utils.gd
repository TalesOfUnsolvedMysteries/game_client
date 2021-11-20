tool
extends Node
# Script en el que se pueden guardar funciones de uso transversal entre todos
# los nodos y scripts del proyecto


func get_screen_coords_for(node: Node) -> Vector2:
	return node.get_viewport().canvas_transform * node.get_global_position()


# Funciones tomadas de ❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱❱
# https://gist.github.com/me2beats/443b40ba79d5b589a96a16c565952419
func snake2camel(string:String)->String:
	var result = PoolStringArray()
	var prev_is_underscore = false
	for ch in string:
		if ch=='_':
			prev_is_underscore = true
		else:
			if prev_is_underscore:
				result.append(ch.to_upper())
			else:
				result.append(ch)
			prev_is_underscore = false


	return result.join('')


func snake2pascal(string:String)->String:
	var result = snake2camel(string)
	result[0] = result[0].to_upper()
	return result


func camel2snake(string:String)->String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())

	return result.join('')


func pascal2snake(string:String)->String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	result[0] = result[0][1]
	return result.join('')
# ❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰❰

# take screenshot
func take_screenshot():
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Wait until the frame has finished before getting the texture.
	yield(VisualServer, "frame_post_draw")

	# Retrieve the captured image.
	var img = get_viewport().get_texture().get_data()

	# Flip it on the y-axis (because it's flipped).
	img.flip_y()

	# Create a texture for it.
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	img.save_png('E:/theta/test.png')
