extends Area2D

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	# When this killzone belongs to an enemy, a downward hit from above is a stomp
	# (the enemy dies and the player bounces). Any other contact kills the player.
	var parent = get_parent()
	if parent and parent.is_in_group("enemy") and parent.has_method("die"):
		if body.velocity.y > 0 and body.global_position.y < parent.global_position.y:
			parent.die()
			body.bounce()
			return

	body.die()
