extends CanvasLayer

func _ready() -> void:
	MenuAnim.open($Root, $Root/Center/Layout/Card)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	GameState.go_to_menu()
