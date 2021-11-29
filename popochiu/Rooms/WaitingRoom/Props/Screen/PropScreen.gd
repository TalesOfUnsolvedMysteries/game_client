tool
extends Prop

onready var _text: RichTextLabel = find_node('Text')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: Looks like it shows important instructions'
	]), 'completed')


func on_look() -> void:
	yield(E.run([
		'Player: A screen with instruction messages'
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func show_message(msg: String) -> void:
	_text.bbcode_text = '[center]%s[/center]' % msg
	yield(get_tree(), 'idle_frame')
