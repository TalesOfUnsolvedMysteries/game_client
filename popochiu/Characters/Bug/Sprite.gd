extends Sprite


func _ready():
	pass


func set_flip_h(new_value):
	var change = $Body.flip_h != new_value
	if !change: return
	$Body.flip_h = new_value
	$Body/Clothes.flip_h = new_value
	$Body/Clothes.position.x = -$Body/Clothes.position.x
	$Head.flip_h = new_value
	$Head/Eyes.flip_h = new_value
	$Legs.flip_h = new_value
	$Legs/Shoes.flip_h = new_value
