extends Control

func _ready() -> void:
	MenuAnim.open(self, $Center/Layout/Card)

func _on_menu_pressed() -> void:
	GameState.go_to_menu()
