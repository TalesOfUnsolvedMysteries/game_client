extends GridContainer

const Fire := preload('Fire.tscn')
const FireTexture := preload('FireTexture.tres')
const Beetle := preload('Beetle.tscn')
const Bee := preload('Bee.tscn')
const LadyBird := preload('LadyBird.tscn')
const Rooster := preload('Rooster.tscn')
const Totem := preload('Totem.tscn')


func _ready() -> void:
	add_child(Fire.instance())
	add_child(Beetle.instance())
	add_child(Bee.instance())
	add_child(LadyBird.instance())
	add_child(Rooster.instance())
	add_child(Totem.instance())
	add_child(Fire.instance())
	
	for t in get_child(0).get_children():
		t.texture = FireTexture.duplicate()
	
	for t in get_child(6).get_children():
		t.texture = FireTexture.duplicate()
	
	get_child(0).get_child(0).texture.region.position.x = 2
	get_child(6).get_child(1).texture.region.position.x = 2
	get_child(6).get_child(2).texture.region.position.x = 2
