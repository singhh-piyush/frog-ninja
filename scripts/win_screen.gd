extends Control

@onready var stars: HBoxContainer = $Center/Layout/Stars

func _ready() -> void:
	MenuAnim.open(self, $Center/Layout/Card)
	# Stars reflect the final level's coins (the last level recorded into GameState).
	StarRating.fill(stars, GameState.last_coins_collected, GameState.last_coins_total)

func _on_menu_pressed() -> void:
	GameState.go_to_menu(get_viewport().get_mouse_position())
