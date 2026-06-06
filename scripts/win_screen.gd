extends CanvasLayer

# Spawned as an overlay over the paused final level when the trophy is reached (end.gd). Hovers over
# the dimmed game and wipes itself in, then "Menu" leaves to the main menu via the normal Transition.

@onready var stars: HBoxContainer = $Root/Center/Layout/Stars
@onready var dim: ColorRect = $Root/Dim
@onready var card: Control = $Root/Center/Layout

func _ready() -> void:
	# Stars reflect the final level's coins (recorded into GameState by end.gd before this spawns).
	StarRating.fill(stars, GameState.last_coins_collected, GameState.last_coins_total)
	PopupWipe.reveal(dim, card)

func _on_menu_pressed() -> void:
	GameState.go_to_menu(get_viewport().get_mouse_position())
