extends CanvasLayer

# Self-contained pause UI: a top-left toggle button plus an overlay with
# Resume / Restart / Main Menu. Instanced once into each level.

var paused_by_me = false
var animating = false

@onready var overlay = $Overlay

func _ready():
	overlay.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_toggle()
		get_viewport().set_input_as_handled()

func _toggle():
	if animating:
		return
	if paused_by_me:
		_close()
	# Don't fight another modal (level-complete popup, death screen) that owns the pause.
	elif not get_tree().paused:
		_open()

func _open():
	animating = true
	await Transition.wipe(_do_open, get_viewport().get_mouse_position())
	animating = false

func _do_open():
	paused_by_me = true
	get_tree().paused = true
	overlay.visible = true

func _close():
	animating = true
	await Transition.wipe(_do_close, get_viewport().get_mouse_position())
	animating = false

func _do_close():
	overlay.visible = false
	get_tree().paused = false
	paused_by_me = false

func _on_menu_button_pressed():
	$MenuButton.bounce()
	_toggle()

func _on_resume_pressed():
	_toggle()

func _on_restart_pressed():
	GameState.restart(get_viewport().get_mouse_position())

func _on_main_menu_pressed():
	GameState.go_to_menu(get_viewport().get_mouse_position())
