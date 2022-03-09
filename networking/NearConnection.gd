extends Resource

#const contract_id = 'tbas.neuromancer.testnet'
const contract_id = 'dev-1645567112557-65255793133999'

var wallet_connection

signal user_loaded
signal credentials_loaded

func _near_setup():
	# test NEAR connection
	var config = {
		'network_id': 'testnet',
		'node_url': 'https://rpc.testnet.near.org',
		'wallet_url': 'https://wallet.testnet.near.org',
	}
	Near.start_connection(config)
	wallet_connection = WalletConnection.new(Near.near_connection)

	if wallet_connection.is_signed_in():
		emit_signal('user_loaded')


func connect():
	if !wallet_connection: return
	wallet_connection.sign_in(contract_id)

	yield(wallet_connection, 'user_signed_in')
	print(wallet_connection.account_id)
	emit_signal('credentials_loaded', wallet_connection.account_id)
	
	print('call nft_register')
	var result = wallet_connection.call_change_method(contract_id, 'nft_register', {'receiver_id': wallet_connection.account_id})
	if result is GDScriptFunctionState:
		result = yield(result, 'completed')
	if result.has('error'):
		print('error')
	elif result.has('warning'):
		print('user key with low balance?')
	elif result.has('message'):
		print('transaction with deposit made?')
	else:
		print('transaction without deposit made?')
	print(result)
	emit_signal('user_loaded')


func get_line():
	if !wallet_connection: return
	var result = Near.call_view_method(contract_id, 'getLine')
	if result is GDScriptFunctionState:
		result = yield(result, 'completed')
	if result.has('error'):
		print(result)
		pass # Error handling here
	else:
		var data = result.data
		print(data)
		return data
	return []


func turns_to_play():
	yield(get_tree(), 'idle_frame')
	if !wallet_connection: return 0
	var result = Near.call_view_method(contract_id, 'turnsToPlay', {'userId': user_id})
	if result is GDScriptFunctionState:
		result = yield(result, 'completed')
	if result.has('error'):
		print(result)
		pass # Error handling here
	else:
		var data = result.data
		print(data)
		return data
	return 0

