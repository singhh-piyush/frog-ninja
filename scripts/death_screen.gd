extends CanvasLayer

func _ready() -> void:
	MenuAnim.open($Root, $Root/Center/Layout/Card)

func _on_restart_pressed() -> void:
	GameState.restart(get_viewport().get_mouse_position())

func _on_main_menu_pressed() -> void:
	GameState.go_to_menu(get_viewport().get_mouse_position())
