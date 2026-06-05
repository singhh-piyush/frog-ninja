extends CanvasLayer

# Self-contained pause UI: a top-left toggle button plus an overlay with
# Resume / Restart / Main Menu. Instanced once into each level.

var paused_by_me = false
var animating = false

@onready var overlay = $Overlay
@onready var overlay_content = $Overlay/Center/VBox

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
	paused_by_me = true
	get_tree().paused = true
	overlay.visible = true
	MenuAnim.open(overlay, overlay_content)

func _close():
	animating = true
	await MenuAnim.close(overlay).finished
	overlay.visible = false
	animating = false
	paused_by_me = false
	get_tree().paused = false

func _on_menu_button_pressed():
	_toggle()

func _on_resume_pressed():
	_toggle()

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	GameState.go_to_menu()
