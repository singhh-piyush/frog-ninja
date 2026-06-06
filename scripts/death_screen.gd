extends CanvasLayer

# Spawned by the player when the last life is lost. Hovers over the dimmed, frozen level and wipes
# in from screen centre (no click origin at death) instead of swapping to a separate screen.

@onready var dim: ColorRect = $Root/Dim
@onready var card: Control = $Root/Center/Layout

func _ready() -> void:
	PopupWipe.reveal(dim, card)

func _on_restart_pressed() -> void:
	GameState.restart(get_viewport().get_mouse_position())

func _on_main_menu_pressed() -> void:
	GameState.go_to_menu(get_viewport().get_mouse_position())
