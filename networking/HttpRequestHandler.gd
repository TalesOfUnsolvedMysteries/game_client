extends Resource
var cookie = ''
signal cookie_set

func set_cookie(_cookie):
	cookie = _cookie
	emit_signal('cookie_set', cookie)


func _process_response (response):
	var result = response[0]
	if result != 0: return {}
	var response_code = response[1]
	var headers = response[2]
	var body = response[3]
	var json = JSON.parse(body.get_string_from_utf8())
	print(json)
	for header in headers:
		if header.begins_with('Set-Cookie'):
			set_cookie(header.replace('Set-Cookie', 'Cookie'))

	return json.get_result()


func _get_request(parent_node: Node, path):
	var http_request = HTTPRequest.new()

	parent_node.add_child(http_request)

	if Globals.SERVER.begins_with('http://127.0.0.1'): http_request.timeout = 2
	var url = '%s%s' % [Globals.SERVER, path]
	var error = 0
	if cookie:
		error = http_request.request(url, [cookie], false, HTTPClient.METHOD_GET)
	else:
		error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

	var response = yield(http_request, 'request_completed')
	parent_node.remove_child(http_request)
	return _process_response(response)


func _post_request(parent_node: Node, path, params):
	var http_request = HTTPRequest.new()
	parent_node.add_child(http_request)

	if Globals.SERVER.begins_with('http://127.0.0.1'): http_request.timeout = 2
	var url = '%s%s' % [Globals.SERVER, path]
	var error = http_request.request(url, ["Content-Type: application/json", cookie], false, HTTPClient.METHOD_POST, JSON.print(params))
	if error != OK:
		print(error)
		push_error("An error occurred in the HTTP request.")
	var response = yield(http_request, 'request_completed')
	parent_node.remove_child(http_request)
	return _process_response(response)

