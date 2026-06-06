extends Node

@onready var score_label = $ScoreLabel

var score = 0
var total_coins = 0

func _ready():
	add_to_group("game_manager")

# Every coin reports itself here on _ready so we know the level's coin total (for the win-screen stars).
func register_coin():
	total_coins += 1

func add_point():
	score += 1
	score_label.text = "you collected " + str(score) + " coins."
