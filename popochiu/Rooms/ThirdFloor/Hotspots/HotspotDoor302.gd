tool
extends Hotspot

onready var secret: Secret = find_node('Secret')

var tries = 0

func _ready():
	secret.connect('wrong_adn_entered', self, '_on_wrong_adn_entered')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if Globals.state.get('ThirdFloor-302_UNLOCKED'):
		yield(E.run([
			C.walk_to_clicked(),
			A.play({
				cue_name = 'sfx_door_open',
				is_in_queue = true
			})
		]), 'completed')
		E.goto_room('FortuneTeller')
	else:
		E.run([
			C.walk_to_clicked(),
			A.play({
				cue_name = 'sfx_door_latch',
				pitch = 4,
				is_in_queue = true
			}),
			"Player: It's locked"
		])


func on_look() -> void:
	yield(E.run([
		C.walk_to_clicked(),
		'Player: this door is different from the other ones',
		'Player: it says biometric security',
		'Player: what does it mean?',
	]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	secret.on_inventory_item_used(item)


func _on_wrong_adn_entered():
	tries += 1
	
	if tries == 1:
		yield(E.run([
			'Player: ahhhh!!',
			'Player: this door gave me a shock'
		]), 'completed')

	if tries == 2:
		yield(E.run([
			'Player: ahhhhhhh!!',
			'Player: that shock was harder!!',
		]), 'completed')

	if tries == 3:
		yield(E.run([
			'Player: ahhhhhhhhhh!!',
			'Player: I can\'t moveeeeee',
			'Player: ahhhhhhhhhhhhhhhh!!',
		]), 'completed')
		if NetworkManager.server or Globals.is_single_test():
			NetworkManager.game_over(NetworkManager.pilot_peer_id, 'electrocuted')

