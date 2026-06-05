extends Node

# Single source of truth for navigation between menu, levels and the win screen.
# Registered as an autoload singleton named "GameState".

const LEVELS := ["res://scenes/Level_1.tscn", "res://scenes/Level_2.tscn"]
const MAIN_MENU := "res://scenes/MainMenu.tscn"
const WIN_SCREEN := "res://scenes/WinScreen.tscn"

func load_level(path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(path)

func go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU)

func advance_from(current_path: String) -> void:
	var idx := LEVELS.find(current_path)
	get_tree().paused = false
	if idx == -1 or idx + 1 >= LEVELS.size():
		get_tree().change_scene_to_file(WIN_SCREEN)
	else:
		get_tree().change_scene_to_file(LEVELS[idx + 1])
