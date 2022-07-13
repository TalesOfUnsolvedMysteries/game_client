tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ métodos virtuales ░░░░
func start() -> void:
	.start()
	

func option_selected(opt: DialogOption) -> void:
	print(opt.id)
	if opt.id == 'ReadLog':
		D.emit_signal('dialog_finished')
		E.current_room.open_killertron_log()
	elif opt.id == 'Scan':
		yield(_handle_scan(), 'completed')
	elif opt.id == 'Hi':
		yield(E.run([
			'Player: Hey Killertron!',
			'Killertron: [matrix clean=30.0 dirty=0.5]Hi[/matrix] [matrix clean=30.0 dirty=1.5]%s[/matrix]' % Globals.bug_name,
			'Player: [shake] How do you know my name?[/shake]',
			'Killertron: [matrix clean=30.0]I know a lot of things [/matrix][matrix clean=30.0 dirty=1.5]%s[/matrix]' % Globals.bug_name
			#'Killertron: [matrix clean=30.0 dirty=0.5]Not too much...[/matrix]\n[matrix clean=30.0 dirty=1.5]I\'m depressed...[/matrix]'
		]), 'completed')
		D.emit_signal('dialog_finished')


func _handle_scan():
	var loading = GlobalTimer.is_active('ScanTimeout')
	var recovering = GlobalTimer.is_active('RecoveryCooldown')
	if recovering:
		yield(E.run([
			'Killertron: [matrix clean=60.0 dirty=1.0]Killertron doesn\'t have energy to scan[/matrix]',
			'Killertron: [matrix clean=60.0 dirty=1.0]Killetron requires time to recover[/matrix]',
		]), 'completed')
		D.emit_signal('dialog_finished')
	elif loading:
		yield(E.run([
			'Killertron: [matrix clean=60.0 dirty=1.0]Please place the subject into the scanning platform[/matrix]',
		]), 'completed')
		D.emit_signal('dialog_finished')
	else:
		yield(E.run([
				'Killertron: [matrix clean=60.0 dirty=1.0]Killertron initializing scanning protocol...[/matrix]',
				'Killertron: [matrix clean=60.0 dirty=1.0]Please place the subject into the scanning platform[/matrix]',
			]), 'completed')
		D.emit_signal('dialog_finished')
		E.current_room.init_killertron_scan()
