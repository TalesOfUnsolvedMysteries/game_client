tool
extends PopochiuRoom

signal fate_decided(die)

onready var _adn_analyzer: PanelContainer = find_node('ADNAnalyzer')
onready var _killetron_log: PanelContainer = find_node('KillertronLog')
onready var painting = $PaintingOverlay2D
onready var _countdown_label: RichTextLabel = find_node('Countdown')

# remote procedures
onready var remote_scan_adn: RemoteCall = find_node('ScanADN')
onready var remote_decide_fate: RemoteCall = find_node('DecideFate')

# global timers
onready var timer_scan_timeout: GlobalTimer = find_node('ScanTimeout')
onready var timer_recovery_cooldown: GlobalTimer = find_node('RecoveryCooldown')

var _bug_in_place = false

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	_adn_analyzer.connect('closed', get_prop('DoctorPC'), 'on_analyzer_closed')
	C.get_character('Killertron').visible = false
	remote_scan_adn.connect('executed', self, '_on_scan_finished')
	remote_decide_fate.connect('executed', self, '_on_fate_decided')
	timer_scan_timeout.connect('step_completed', self, '_on_scan_loading_step')
	timer_scan_timeout.connect('timeout', self, '_on_scan_timeout')
	timer_recovery_cooldown.connect('step_completed', self, '_on_cooldown_step')
	timer_recovery_cooldown.connect('timeout', self, '_on_cooldown_timeout')
	
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
	timer_scan_timeout.start()
	_on_scan_loading_step(0)
	_countdown_label.show()

func _on_scan_loading_step(_elapsed_time):
	_countdown_label.bbcode_text = '[center]%d[/center]' % round(timer_scan_timeout.time_target - _elapsed_time)

func _on_scan_timeout():
	_countdown_label.hide()
	if _bug_in_place: _check_scan()
	else:
		yield(E.run([
			'Killertron: No bug to scan!',
			'Killertron: Killertron can\'t process any ADN',
			'Killertron: Killertron needs to rest a little',
		]), 'completed')
		timer_recovery_cooldown.start()

func _check_scan():
	if Globals.session_state.get('bug_scanned', false):
		yield(E.run([
			'Killertron: Killertron detected that you were already scanned!',
			'Killertron: Killertron doesn\'t need your ADN'
		]), 'completed')
		return
	yield(E.run([
		'Killertron: Killertron initializating scanning!'
	]), 'completed')
	yield(remote_scan_adn.execute(), 'completed')

func bug_on_platform():
	if GlobalTimer.is_active('ScanTimeout'):
		_bug_in_place = true
		G.block()

func _on_scan_finished(response):
	var matched = response[0]
	var killertron_target_key = response[1]
	_killetron_log.load_data()
	if matched:
		yield(E.run([
			'Killertron: Killertron found something interesting!'
		]), 'completed')
		G.emit_signal('nft_won', Globals.NFTs[killertron_target_key])
		yield(G, 'nft_shown')
		yield(E.run([
			'Player: [shake]oh my lord...[/shake]'
		]), 'completed')
	else:
		yield(E.run([
			'Killertron: Killertron will decide your fate',
			'Player: ???'
		]), 'completed')
	remote_decide_fate.execute([matched])

func _on_cooldown_step(_elapsed_time):
	pass

func _on_cooldown_timeout():
	if Globals.session_state.get('bug_scanned', false): return
	yield(E.run([
		'Killertron: Killertron is ready to scan again!',
		'Killertron: if you are brave enough!',
	]), 'completed')


func _on_fate_decided(die):
	Globals.set_session_state('bug_scanned', true)
	if die:
		# block screen for player?
		# TODO animation for kill
		yield(E.run([
			'Killertron: tasty!',
		]), 'completed')
		if NetworkManager.server or Globals.is_single_test():
			NetworkManager.game_over(NetworkManager.pilot_peer_id, 'disintegrated')
	else:
		yield(E.run([
			'Killertron: get out of here!',
		]), 'completed')
		timer_recovery_cooldown.start()
	_bug_in_place = false
	G.done()
