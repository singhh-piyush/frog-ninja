extends CanvasLayer

# In-level heads-up display: shows remaining lives as hearts pinned to the top-right of the screen.
# Lives live in the GameState autoload (they survive the scene reload that respawning uses), so on
# _ready we just read GameState.lives and show that many full hearts, the rest as empty outlines.

const SHEET := preload("res://assets/HealthUI.png")
const FULL := Rect2(0, 0, 11, 11)     # top-left cell: full red heart
const EMPTY := Rect2(22, 66, 11, 11)  # bottom-right cell: empty outline heart

@onready var hearts: HBoxContainer = $Margin/Hearts

func _ready() -> void:
	var lives := GameState.lives
	for i in hearts.get_child_count():
		var heart := hearts.get_child(i) as TextureRect
		var atlas := AtlasTexture.new()
		atlas.atlas = SHEET
		atlas.region = FULL if i < lives else EMPTY
		heart.texture = atlas
