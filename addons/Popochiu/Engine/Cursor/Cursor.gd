extends CanvasLayer

enum Type {
	NONE,
	ACTIVE,
	DOWN,
	IDLE,
	LEFT,
	LOOK,
	RIGHT,
	SEARCH,
	TALK,
	UP,
	USE,
	WAIT,
}

var is_blocked := false
sync var cursor_position:Vector2 = Vector2(0,0)

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor()

var counter = 0
func _process(delta):
	counter += delta
	var mouse_position = $AnimatedSprite.get_global_mouse_position()
	
	# should wrap this is server and has network into the network manager
	# to validate connection issues
	if get_tree().is_network_server():
		# mouse position would display the position but it wont trigger the on hover
		# events..
		#mouse_position = cursor_position
		# warp mouse would handle the mouse as it is 
		if counter > 10 and counter < 50:
			get_viewport().warp_mouse(cursor_position)
	elif get_tree().has_network_peer():
		rset_unreliable('cursor_position', mouse_position)
	$AnimatedSprite.position = mouse_position
	$Sprite.position = mouse_position
		

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func set_cursor(type := Type.IDLE) -> void:
	if is_blocked: return
	
	var anim_name: String = Type.keys()[Type.IDLE]
	if Type.values().has(type):
		anim_name = Type.keys()[type]
	$AnimatedSprite.play(anim_name.to_lower())


func set_item_cursor(texture: Texture) -> void:
	$AnimatedSprite.hide()
	$Sprite.texture = texture
	$Sprite.show()


func remove_item_cursor() -> void:
	$Sprite.texture = null
	$Sprite.hide()
	$AnimatedSprite.show()


func toggle_visibility(is_visible: bool) -> void:
	$AnimatedSprite.visible = is_visible
	$Sprite.visible = is_visible


func block() -> void:
	is_blocked = true


func unlock() -> void:
	is_blocked = false
