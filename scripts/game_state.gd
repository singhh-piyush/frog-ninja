extends Node

# Single source of truth for navigation between menu, levels and the win screen.
# Registered as an autoload singleton named "GameState". All scene changes route through the
# Transition autoload so they play the black circle wipe; `from` is the click point in viewport
# pixels (defaults to screen centre when off-screen / unspecified).
#
# Also owns run state that must survive a scene reload (which is how respawning works):
#   lives  - reset to 3 whenever a *new* level is entered (load_level / next level / restart);
#            decremented by the player on damage. respawn() reloads the level WITHOUT resetting it.
#   last_coins_collected / last_coins_total - recorded at each level completion so the WinScreen
#            can show a star rating for the final level's coins.

const LEVELS := ["res://scenes/Level_1.tscn", "res://scenes/Level_2.tscn"]
const MAIN_MENU := "res://scenes/MainMenu.tscn"
const WIN_SCREEN := "res://scenes/WinScreen.tscn"

const MAX_LIVES := 3

var lives := MAX_LIVES
var last_coins_collected := 0
var last_coins_total := 0

func load_level(path: String, from := Vector2(-1, -1)) -> void:
	lives = MAX_LIVES
	Transition.change_scene(path, from)

func go_to_menu(from := Vector2(-1, -1)) -> void:
	Transition.change_scene(MAIN_MENU, from)

func restart(from := Vector2(-1, -1)) -> void:
	lives = MAX_LIVES
	Transition.reload_scene(from)

# Lose-a-life reload: restart the level from the beginning but keep the (already decremented) lives.
func respawn(from := Vector2(-1, -1)) -> void:
	Transition.reload_scene(from)

func is_last_level(path: String) -> bool:
	var idx := LEVELS.find(path)
	return idx == -1 or idx + 1 >= LEVELS.size()

func advance_from(current_path: String, from := Vector2(-1, -1)) -> void:
	if is_last_level(current_path):
		Transition.change_scene(WIN_SCREEN, from)
	else:
		lives = MAX_LIVES
		Transition.change_scene(LEVELS[LEVELS.find(current_path) + 1], from)
