extends Node2D

const NORMAL_SPEED = 60
const CHASE_SPEED = 120

var direction = 1
var dead = false

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_player_left = $RayCastPlayerLeft
@onready var ray_cast_player_right = $RayCastPlayerRight
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	add_to_group("enemy")

func _process(delta):
	if dead:
		return

	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true

	var speed = NORMAL_SPEED
	var player_detected = false

	if ray_cast_player_right.is_colliding() and ray_cast_player_right.get_collider().is_in_group("player"):
		direction = 1
		speed = CHASE_SPEED
		player_detected = true
	elif ray_cast_player_left.is_colliding() and ray_cast_player_left.get_collider().is_in_group("player"):
		direction = -1
		speed = CHASE_SPEED
		player_detected = true

	if player_detected:
		animated_sprite.play("run")
	else:
		animated_sprite.play("default")

	position.x += direction * speed * delta

# Called when the player stomps this enemy.
func die():
	if dead:
		return
	dead = true
	animated_sprite.play("hit")
	$killzone/CollisionShape2D.set_deferred("disabled", true)
	await animated_sprite.animation_finished
	queue_free()
