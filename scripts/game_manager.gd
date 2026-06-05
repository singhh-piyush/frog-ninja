extends Node

@onready var score_label = $ScoreLabel

var score = 0;

func _ready():
	add_to_group("game_manager")

func add_point():
	score += 1
	score_label.text = "you collected " + str(score) + " coins."
