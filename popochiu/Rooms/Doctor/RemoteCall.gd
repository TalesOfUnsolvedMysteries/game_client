extends RemoteCall

func function_call(args:=[]):
	yield(get_tree(), 'idle_frame')
	self.response = []
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
	
	self.response = [matched, killetron_target_key]
