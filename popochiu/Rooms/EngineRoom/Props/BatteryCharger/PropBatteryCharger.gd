tool
extends Prop

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	if Engine.editor_hint:
		return
	
	_load_battery_power(GlobalTimer.get_time('ChargeTimer'))
	$ChargeTimer.connect('step_completed', self, '_update_charging_status')
	$ChargeTimer.connect('timeout', self, '_battery_charged')
	
	if !Globals.state.get('EngineRoom-CHARGE_SOCKET_WITH_BATTERY'):
		$Sprite.frame = 0
		$ChargingProgress.value = 0
	else:
		$Sprite.frame = 1

	I.connect('item_discarded', self, '_on_item_discarded')


func _exit_tree() -> void:
	pass

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_WITH_BATTERY'):
		if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
			E.run(["Player: I don't need that anymore."])
		
		return
	
	if $ChargeTimer._global_ref and $ChargeTimer._global_ref._playing:
		yield(E.run([
			C.walk_to_clicked(),
			'Player: Should I extract the battery?'
		]), 'completed')
		
		var answer: DialogOption = yield(E.show_inline_dialog(['Yes', 'No']), 'completed')
		if answer.id == 'Opt1':
			# check for space in inventory first
			if I._items_count == 3: # inventory is full
				yield(E.run([
					'Player: I can\'t carry anymore items!'
				]), 'completed')
				return
			Globals.set_state('BATTERY_LAST_LOCATION', 'EngineRoom-CHARGE_SOCKET_WITH_BATTERY')
			E.run([
				_pause_charging(),
				A.play({cue_name='sfx_battery_out_charger'}),
				I.add_item('MotherboardBattery'),
				'Player: Fuck the charging!'
			])
		else:
			E.run(['Player: Yeah. Let it charge in peace.'])
	elif Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		Globals.set_state('BATTERY_LAST_LOCATION', 'EngineRoom-CHARGE_SOCKET_WITH_BATTERY')
		# check for space in inventory first
		if I._items_count == 3: # inventory is full
			yield(E.run([
				C.walk_to_clicked(),
				'Player: I can\'t carry anymore items!'
			]), 'completed')
			return
		yield(E.run([
			C.walk_to_clicked(),
			'Player: Great. Now the battery is fully charged',
			A.play({cue_name='sfx_battery_out_charger'}),
			I.add_item('MotherboardBattery')
		]), 'completed')
		
		$Sprite.frame = 0
		$ChargingProgress.value = 0
	else:
		yield(E.run([
			C.walk_to_clicked(),
			"Player: I don´t know what to do with this... or how to use it"
		]), 'completed')


func on_look() -> void:
	yield(E.run([
		'Player: What is that?'
	]), 'completed')


func on_item_used(item) -> void:
	if item.script_name == 'MotherboardBattery':
		if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
			E.run([
				'Player: The battery is fully charged already.',
				'Player: There is no point in charging it again.'
			])
		else:
			Globals.set_state('EngineRoom-CHARGE_SOCKET_WITH_BATTERY', true)
			yield(E.run([
				C.walk_to_clicked(),
				I.remove_item(item.script_name),
				A.play({cue_name='sfx_battery_in_charger'}),
				'Player: This should charge the battery.',
				'Player: ...and it will take just %d minutes.' %\
				($ChargeTimer.time_target / 60)
			]), 'completed')
			
			start_charging()

func start_charging():
	$ChargeTimer.start()
	$Sprite.frame = 1
	_load_battery_power(GlobalTimer.get_time('ChargeTimer'))

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░

func _update_charging_status(_elapsed_time) -> void:
	_load_battery_power(_elapsed_time)
	A.play({cue_name = 'sfx_battery_charging_progress', is_in_queue = false})


func _battery_charged() -> void:
	E.run([
		A.play({cue_name = 'sfx_battery_charging_done', is_in_queue = true}),
		'Player: Looks like the battery is charged'
	])

func _load_battery_power(_elapsed_time):
	$ChargingProgress.value = round(100.0 * _elapsed_time / $ChargeTimer.time_target)

func _pause_charging() -> void:
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		return yield(get_tree(), 'idle_frame')
	
	$ChargeTimer.pause()
	$Sprite.frame = 0
	$ChargingProgress.value = 0
	A.play({cue_name = 'sfx_battery_charging_stop', is_in_queue = false})
	
	yield(get_tree(), 'idle_frame')

func _on_item_discarded(item: InventoryItem):
	if item.script_name == 'MotherboardBattery':
		if Globals.state.get('BATTERY_LAST_LOCATION') == 'EngineRoom-CHARGE_SOCKET_WITH_BATTERY':
			start_charging()
