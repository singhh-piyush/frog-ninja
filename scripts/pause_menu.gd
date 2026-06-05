extends CanvasLayer

# Self-contained pause UI: a top-left toggle button plus an overlay with
# Resume / Restart / Main Menu. Instanced once into each level.

var paused_by_me = false

@onready var overlay = $Overlay

func _ready():
	overlay.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_toggle()
		get_viewport().set_input_as_handled()

func _toggle():
	# Don't fight another modal (level-complete popup, death screen) that owns the pause.
	if get_tree().paused and not paused_by_me:
		return
	paused_by_me = not paused_by_me
	get_tree().paused = paused_by_me
	overlay.visible = paused_by_me

func _on_menu_button_pressed():
	_toggle()

func _on_resume_pressed():
	_toggle()

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	GameState.go_to_menu()
