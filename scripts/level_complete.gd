extends CanvasLayer

@onready var coins_label = %CoinsLabel

func _ready() -> void:
	MenuAnim.open($Root, $Root/Center/Layout/Card)

func set_coins(n: int) -> void:
	coins_label.text = "Coins collected: %d" % n

func _on_next_pressed() -> void:
	GameState.advance_from(get_tree().current_scene.scene_file_path, get_viewport().get_mouse_position())
