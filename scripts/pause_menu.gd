extends CanvasLayer

# Self-contained pause UI: a top-left gear toggle plus a popup with Resume / Restart / Main Menu.
# Instanced once into each level. The popup hovers over the dimmed, frozen game and wipes in from
# the gear/click point (PopupWipe) — no full-screen black cover. The gear stays drawn on top of the
# dim (it's the last child of this CanvasLayer) so clicking it again closes the menu.

var paused_by_me = false
var animating = false

@onready var overlay: Control = $Overlay
@onready var dim: ColorRect = $Overlay/Dim
@onready var card: Control = $Overlay/Center/Card

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
	paused_by_me = true
	get_tree().paused = true
	overlay.visible = true
	await PopupWipe.reveal(dim, card, get_viewport().get_mouse_position())
	animating = false

func _close():
	animating = true
	await PopupWipe.conceal(dim, card, get_viewport().get_mouse_position()).finished
	overlay.visible = false
	get_tree().paused = false
	paused_by_me = false
	animating = false
	# Drop focus so the now-hidden buttons don't swallow the next Space/Enter (which is also
	# `jump`/`ui_accept`) and re-trigger the gear, reopening the menu.
	get_viewport().gui_release_focus()

func _on_menu_button_pressed():
	$MenuButton.bounce()
	_toggle()

func _on_resume_pressed():
	_toggle()

func _on_restart_pressed():
	GameState.restart(get_viewport().get_mouse_position())

func _on_main_menu_pressed():
	GameState.go_to_menu(get_viewport().get_mouse_position())
