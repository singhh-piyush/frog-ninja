extends Control

@onready var main_panel = $MainPanel
@onready var level_panel = $LevelSelectPanel

func _ready():
	main_panel.visible = true
	level_panel.visible = false

func _on_start_pressed():
	GameState.load_level(GameState.LEVELS[0])

func _on_level_select_pressed():
	main_panel.visible = false
	level_panel.visible = true

func _on_back_pressed():
	level_panel.visible = false
	main_panel.visible = true

func _on_level_1_pressed():
	GameState.load_level("res://scenes/Level_1.tscn")

func _on_level_2_pressed():
	GameState.load_level("res://scenes/Level_2.tscn")
