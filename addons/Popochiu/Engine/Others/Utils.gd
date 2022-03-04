tool
extends Node
# Script en el que se pueden guardar funciones de uso transversal entre todos
# los nodos y scripts del proyecto


func get_screen_coords_for(node: Node) -> Vector2:
	return node.get_viewport().canvas_transform * node.get_global_position()


# Obtiene un elemento al azar de un arrego
func get_random_array_element(arr: Array):
	randomize()
	var idx := randi() % arr.size()
	return arr[idx]


# Obtiene un índice (posición) al azar de un arreglo
func get_random_array_idx(arr: Array) -> int:
	randomize()
	var idx := randi() % arr.size()
	return idx


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
func take_screenshot(_name):
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
	if _name:
		img.save_png(_name)
	return tex


func generate_word(length):
	var chars = 'abcdefghijklmnopqrstuvwxyz#$%@?ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

# Serves as, an interface?, for calling methods in the server (master) without
# having to create specific functions in each Node that wants to do so >>>>>>>>>
func invoke(node: Node, method: String, args := [], ignore := false) -> void:
	if not ignore:
		node.callv(method, args)
	
	if NetworkManager.isPilot():
		# Check if any of the args is a Node
		var _args := []
		
		for arg in args:
			if arg is Node:
				_args.append(arg.get_path())
			elif arg is Resource:
				_args.append(arg.resource_path)
			else:
				_args.append(arg)
		
		rpc_id(1, '_net_invoke', node.get_path(), method, _args)


remote func _net_invoke(node_path: NodePath, method: String, args := []) -> void:
	if NetworkManager.isServerWithPilot():
		# Check if any of the args is a NodePath so the Node can be sent to the
		# target method
		var _args := []
		
		for arg in args:
			if arg is NodePath:
				_args.append(get_node(arg))
			elif typeof(arg) == TYPE_STRING and '.tres' in arg:
				_args.append(load(arg))
			else:
				_args.append(arg)
		
		get_node(node_path).callv(method, _args)
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
