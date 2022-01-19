tool
extends Prop


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos de Godot ░░░░
func _ready() -> void:
	$ChargingProgress.value = Globals.battery_power
	
	if Globals.state.get('EngineRoom-CHARGING_BATTERY'):
		_listen_battery_charging(false)
	elif not Globals.state.get('EngineRoom-MOTHERBOARD_WITHOUT_BATTERY'):
		$Sprite.frame = 0
		$ChargingProgress.value = 0


func _exit_tree() -> void:
	if Globals.is_connected(
		'battery_charge_updated', self, '_update_charging_status'
	):
		Globals.disconnect('battery_charge_updated', self, '_update_charging_status')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	if not Globals.state.get('EngineRoom-MOTHERBOARD_WITHOUT_BATTERY'):
		if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
			E.run(["Player: I don't need that anymore."])
		
		return
	
	if Globals.state.get('EngineRoom-CHARGING_BATTERY'):
		yield(E.run(['Player: Should I extract the battery?']), 'completed')
		
		var answer: DialogOption = yield(E.show_inline_dialog(['Yes', 'No']), 'completed')
		if answer.id == 'Opt1':
			E.run([
				C.walk_to_clicked(),
				_stop_charging(),
				I.add_item('MotherboardBattery'),
				'Player: Fuck the charging!'
			])
		else:
			E.run(['Player: Yeah. Let it charge in peace.'])
	elif Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		yield(E.run([
			C.walk_to_clicked(),
			'Player: Great. Now the battery is fully charged',
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


func on_item_used(item: InventoryItem) -> void:
	if item.script_name == 'MotherboardBattery':
		if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
			E.run([
				'Player: The battery is fully charged already.',
				'Player: There is no point in charging it again.'
			])
		else:
			yield(E.run([
				C.walk_to_clicked(),
				I.remove_item(item.script_name),
				_listen_battery_charging(),
				'Player: This should charge the battery.',
				'Player: ...and it will take just %d minutes.' %\
				(Globals.BATTERY_CHARGING_TIME / 60)
			]), 'completed')
			
			Globals.start_battery_charging()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos privados ░░░░
func _listen_battery_charging(is_in_queue := true) -> void:
	if is_in_queue: yield()
	
	$Sprite.frame = 1
	Globals.connect('battery_charge_updated', self, '_update_charging_status')
	
	if is_in_queue: yield(get_tree(), 'idle_frame')


func _update_charging_status() -> void:
	$ChargingProgress.value = Globals.battery_power
	
	if $ChargingProgress.value == 100:
		E.run([
			A.play({cue_name = 'sfx_battery_charging_done', is_in_queue = true}),
			'Player: Looks like the battery is charged'
		])
	else:
		A.play({cue_name = 'sfx_battery_charging_progress', is_in_queue = false})


func _stop_charging() -> void:
	yield()
	
	if Globals.state.get('EngineRoom-MOTHERBOARD_BATTERY_FULL'):
		return yield(get_tree(), 'idle_frame')
	
	Globals.stop_battery_charging()
	Globals.disconnect('battery_charge_updated', self, '_update_charging_status')
	
	$Sprite.frame = 0
	$ChargingProgress.value = 0
	A.play({cue_name = 'sfx_battery_charging_stop', is_in_queue = false})
	
	yield(get_tree(), 'idle_frame')
