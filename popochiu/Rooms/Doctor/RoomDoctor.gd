tool
extends PopochiuRoom

signal adn_matched(matched, nft_key)
signal fate_decided(die)

onready var _adn_analyzer: PanelContainer = find_node('ADNAnalyzer')
onready var _killetron_log: PanelContainer = find_node('KillertronLog')
onready var painting = $PaintingOverlay2D

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_adn_analyzer.connect('closed', get_prop('DoctorPC'), 'on_analyzer_closed')
	C.get_character('Killertron').visible = false
	self.connect('adn_matched', self, '_on_adn_matched')
	self.connect('fate_decided', self, '_on_fate_decided')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_room_entered() -> void:
	A.play({cue_name = 'sfx_door_close',is_in_queue = false})


func on_room_transition_finished() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos públicos ░░░░
func turn_on_analyzer(adn_sample := '') -> void:
	_adn_analyzer.appear(adn_sample)


func open_killertron_log():
	_killetron_log.appear()

func init_killertron_scan():
	if Globals.session_state.get('bug_scanned', false):
		yield(E.run([
			'Killertron: Killertron detected that you were already scanned!',
			'Killertron: Killertron doesn\'t need your ADN'
		]), 'completed')
		return
	yield(E.run([
		'Killertron: Killertron initializating scanning!'
	]), 'completed')
	yield(_apply_scanning(), 'completed')
	

func _apply_scanning():
	yield(get_tree(), 'idle_frame')
	if !NetworkManager.server and !Globals.is_single_test(): return
	# read players adn
	# compare it against target adn // server mode async secret
	var collected_adns: Array = Globals.state.get('Killertron_COLLECTED_ADN', [])
	var scanned_adns: Array = Globals.state.get('Killertron_SCANNED_ADN', [])
	var killetron_target_key = 'KILLETRON_TARGET_ADN%d' % [collected_adns.size() - 2]
	var target_adn: String = SecretsKeeper.get(killetron_target_key)
	var current_adn: String = Globals.bug_adn
	var i = 0
	var matched_genes = ''
	print('%s -> %s' % [current_adn, target_adn])
	for gene in current_adn:
		var matches = 0
		if target_adn.find(gene) != -1:
			matches = 1
			if gene == target_adn[i]:
				matches = 2
		matched_genes += '%d' % matches
		i += 1

	scanned_adns.push_front([current_adn, matched_genes])
	if scanned_adns.size() > 6:
		scanned_adns.pop_back()
	Globals.set_state('Killertron_SCANNED_ADN', scanned_adns)
	Globals.set_state('Killertron_TOTAL_SCANNED', Globals.state.get('Killertron_TOTAL_SCANNED', 0) + 1)

	var matched = matched_genes == '222222'
	if matched:
		collected_adns.push_back(current_adn)
		Globals.set_state('Killertron_COLLECTED_ADN', collected_adns)
	
	emit_signal('adn_matched', matched, killetron_target_key)
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'remote_adn_matched', matched, killetron_target_key)


remote func remote_adn_matched(matched, killetron_target_key):
	if NetworkManager.isPilot():
		emit_signal('adn_matched', matched, killetron_target_key)


func _on_adn_matched(matched, killertron_target_key):
	_killetron_log.load_data()
	if matched:
		G.emit_signal('nft_won', killertron_target_key)
		yield(G, 'nft_shown')

	yield(E.run([
		'Killertron: Killertron decides your fate',
		'Player: ???'
	]), 'completed')
	check_kill(matched)


func check_kill(matched):
	yield(get_tree(), 'idle_frame')
	if !NetworkManager.server and !Globals.is_single_test(): return
	randomize()
	var _kill_chance = 100 if matched else 50
	var _kill = randi()%100 < _kill_chance
	emit_signal('fate_decided', _kill)
	if !Globals.is_single_test():
		rpc_id(NetworkManager.pilot_peer_id, 'remote_fate_decided', _kill)

remote func remote_fate_decided(die):
	if NetworkManager.isPilot():
		emit_signal('fate_decided', die)

func _on_fate_decided(die):
	Globals.set_session_state('bug_scanned', true)
	if die:
		yield(E.run([
			'Killertron: Im going to eat you!!!',
		]), 'completed')
		if NetworkManager.server or Globals.is_single_test():
			NetworkManager.game_over(NetworkManager.pilot_peer_id, 'disintegrated')
	else:
		yield(E.run([
			'Killertron: get out of here!',
		]), 'completed')
		
