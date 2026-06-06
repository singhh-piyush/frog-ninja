extends Control

const STAR := preload("res://assets/Free/Items/Star.png")
const STAR_FRAME := Rect2(0, 0, 32, 32)  # first gold star in the sheet

@onready var stars: HBoxContainer = $Center/Layout/Stars

func _ready() -> void:
	MenuAnim.open(self, $Center/Layout/Card)
	_show_stars()

# Rate the final level's coins: 1/3 of its coins -> 1 star, 2/3 -> 2, all -> 3.
func _show_stars() -> void:
	var total := GameState.last_coins_total
	var ratio := float(GameState.last_coins_collected) / total if total > 0 else 0.0
	var earned := 0
	if ratio >= 1.0:
		earned = 3
	elif ratio >= 2.0 / 3.0:
		earned = 2
	elif ratio >= 1.0 / 3.0:
		earned = 1

	for i in stars.get_child_count():
		var star := stars.get_child(i) as TextureRect
		var atlas := AtlasTexture.new()
		atlas.atlas = STAR
		atlas.region = STAR_FRAME
		star.texture = atlas
		# Earned stars show in full gold; the rest are dimmed to read as empty slots.
		star.modulate = Color(1, 1, 1) if i < earned else Color(0.15, 0.15, 0.15, 0.55)

func _on_menu_pressed() -> void:
	GameState.go_to_menu(get_viewport().get_mouse_position())
