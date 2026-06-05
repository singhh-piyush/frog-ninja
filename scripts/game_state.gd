extends Node

# Single source of truth for navigation between menu, levels and the win screen.
# Registered as an autoload singleton named "GameState". All scene changes route through the
# Transition autoload so they play the white circle wipe; `from` is the click point in viewport
# pixels (defaults to screen centre when off-screen / unspecified).

const LEVELS := ["res://scenes/Level_1.tscn", "res://scenes/Level_2.tscn"]
const MAIN_MENU := "res://scenes/MainMenu.tscn"
const WIN_SCREEN := "res://scenes/WinScreen.tscn"

func load_level(path: String, from := Vector2(-1, -1)) -> void:
	Transition.change_scene(path, from)

func go_to_menu(from := Vector2(-1, -1)) -> void:
	Transition.change_scene(MAIN_MENU, from)

func restart(from := Vector2(-1, -1)) -> void:
	Transition.reload_scene(from)

func advance_from(current_path: String, from := Vector2(-1, -1)) -> void:
	var idx := LEVELS.find(current_path)
	if idx == -1 or idx + 1 >= LEVELS.size():
		Transition.change_scene(WIN_SCREEN, from)
	else:
		Transition.change_scene(LEVELS[idx + 1], from)
