extends CanvasLayer

@onready var stars: HBoxContainer = $Root/Center/Layout/Stars

func _ready() -> void:
	# This level's coins (recorded into GameState by end.gd just before this popup spawns).
	StarRating.fill(stars, GameState.last_coins_collected, GameState.last_coins_total)

func _on_next_pressed() -> void:
	GameState.advance_from(get_tree().current_scene.scene_file_path, get_viewport().get_mouse_position())
