extends CanvasLayer

func _on_next_pressed() -> void:
	GameState.advance_from(get_tree().current_scene.scene_file_path, get_viewport().get_mouse_position())
