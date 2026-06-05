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

	var gm = get_tree().get_first_node_in_group("game_manager")
	var coins = gm.score if gm else 0

	var popup = preload("res://scenes/LevelComplete.tscn").instantiate()
	get_tree().current_scene.add_child(popup)
	popup.set_coins(coins)
	get_tree().paused = true
