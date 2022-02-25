extends Label

var local_timer = 0
func _ready():
	pass # Replace with function body.

func _process(delta):
	if NetworkManager.isPilot() || NetworkManager.isServerWithPilot():
		if local_timer > 30 and NetworkManager.get_countdown_timer() < 30:
			print('30 seconds remain!')
			self.modulate = Color.red;
		local_timer = NetworkManager.get_countdown_timer()
		
		var mins = int(local_timer/60)
		var seconds = int(local_timer) % 60
		var _text = '0%d:' % mins
		if seconds < 10:
			_text = '%s0' % _text
		self.text = '%s%d' % [_text, seconds]
