extends Control

@onready var main_panel = $MainPanel
@onready var level_panel = $LevelSelectPanel

var switching = false

func _ready():
	main_panel.visible = true
	level_panel.visible = false
	MenuAnim.open(self, main_panel)

func _on_start_pressed():
	GameState.load_level(GameState.LEVELS[0])

func _on_level_select_pressed():
	await _swap(main_panel, level_panel)

func _on_back_pressed():
	await _swap(level_panel, main_panel)

func _swap(from_panel: Control, to_panel: Control):
	if switching:
		return
	switching = true
	await MenuAnim.close(from_panel).finished
	from_panel.visible = false
	to_panel.visible = true
	MenuAnim.open(to_panel, to_panel)
	switching = false

func _on_level_1_pressed():
	GameState.load_level("res://scenes/Level_1.tscn")

func _on_level_2_pressed():
	GameState.load_level("res://scenes/Level_2.tscn")
