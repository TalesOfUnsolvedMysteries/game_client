tool
extends Prop

export var balance_config = [2.0, 0.5, 0.8, 0.7]
export var weight_index = 0

var balance = 0
signal vase_placed(item)

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func on_interact() -> void:
	yield(E.run([]), 'completed')


func on_look() -> void:
	yield(E.run([]), 'completed')


func on_item_used(item: InventoryItem) -> void:
	if !item.script_name.match('Vase*'):
		print('not a valid item')
		return
	print(item.script_name)
	I.remove_item(item.script_name, false)
	var weights = Globals.state.get('Penthouse_WEIGHTS_ON_Shelfs')
	weights[weight_index] = item.weight
	Globals.set('Penthouse_WEIGHTS_ON_Shelfs', weights)
	emit_signal('vase_placed', item.script_name)

func evaluate():
	var weights = Globals.state.get('Penthouse_WEIGHTS_ON_Shelfs')
	print('this balance >>>>>>> ', weight_index)
	print(weights[0]*balance_config[0])
	print(weights[1]*balance_config[1])
	print(weights[2]*balance_config[2])
	print(weights[3]*balance_config[3])
	balance = weights[0]*balance_config[0] + weights[1]*balance_config[1] + weights[2]*balance_config[2] + weights[3]*balance_config[3]
	print('this balance: ', balance)

