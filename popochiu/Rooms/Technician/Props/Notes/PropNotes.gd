tool
extends Prop

export(Array, String, MULTILINE) var pages = []
export var background: Texture = null
onready var _secret: Secret = get_node('Secret')

func _ready():
	_load_secret_codes()

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		C.face_clicked(),
		'Player: Lets check this notes... because I am a chismoso.'
	]), 'completed')
	
	G.show_documents({pages = pages, bg = background})


func on_look() -> void:
	yield(E.run([
		C.face_clicked(),
		'Player: A notebook.'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	.on_item_used(item)


func _load_secret_codes():
	var _json = JSON.parse(_secret._secret)
	var _codes = _json.result
	var formatted_text = ''
	var i = 0
	var _space_length = 14
	var _previous_length = 0
	for key in _codes.keys():
		var pair = '%s: %s' % [key, _codes[key]]
		formatted_text += pair
		i+=1
		if i%2 == 0: formatted_text += '\n'
		else: formatted_text += ' '.repeat(_space_length - pair.length())
	pages[1] = "Codes to reset the mainboard:\n\n%s\n\nThis must be done each time the battery is plugged in." % formatted_text
