extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	print("YOU DIED!")
	#Engine.time_scale = 0.5
	var player = body as Node2D  # Assuming the player node is directly entering the area
	var animated_sprite = player.get_node("AnimatedSprite2D")
	if animated_sprite:
		animated_sprite.play("hit")
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
