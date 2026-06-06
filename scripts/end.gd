extends Area2D

var triggered = false

func _on_body_entered(body):
	if triggered or not body.is_in_group("player"):
		return
	triggered = true

	# Stop the player at the flag and let the activation animation play out fully
	# before we pause the tree and show the popup.
	if body.has_method("freeze"):
		body.freeze()
	$AnimatedSprite2D.play("pressed")
	await $AnimatedSprite2D.animation_finished

	# Iris to black, then show the level-complete popup over the paused level.
	Transition.wipe(_show_level_complete)

func _show_level_complete():
	# Record this level's coin result so the WinScreen can rate the final level with stars.
	var gm = get_tree().get_first_node_in_group("game_manager")
	GameState.last_coins_collected = gm.score if gm else 0
	GameState.last_coins_total = gm.total_coins if gm else 0

	var popup = preload("res://scenes/LevelComplete.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	get_tree().paused = true
