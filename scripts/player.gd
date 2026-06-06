extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const BOUNCE_VELOCITY = -220.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D

var jump_count = 0
var can_double_jump = true
var is_double_jumping = false

var current_animation = ""
var dead = false
var frozen = false

func _ready():
	add_to_group("player")
	print("Player is ready and added to group 'player'")

func _physics_process(delta):
	if dead or frozen:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_count = 1
			is_double_jumping = false
			play_animation("jump")
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
			jump_count = 2
			is_double_jumping = true
			play_animation("DoubleJump")

	if is_on_floor():
		jump_count = 0
		can_double_jump = true
		is_double_jumping = false

	var direction = Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	if is_on_floor():
		if direction == 0:
			play_animation("idle")
		else:
			play_animation("run")
	else:
		if is_double_jumping:
			play_animation("DoubleJump")
		elif velocity.y < 0:
			play_animation("jump")
		else:
			play_animation("fall")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func play_animation(animation_name):
	if current_animation != animation_name:
		current_animation = animation_name
		animated_sprite_2d.play(animation_name)

# Called when the player stomps an enemy: pop back up.
func bounce():
	velocity.y = BOUNCE_VELOCITY

# Called at the level trophy to stop the player without triggering a death.
func freeze():
	frozen = true
	velocity = Vector2.ZERO
	play_animation("idle")

# Called by killzones (pits and enemies) when the player takes a fatal hit. Costs one life; the
# death screen only appears once all lives are gone (handled in _on_timer_timeout).
func die():
	if dead:
		return
	dead = true
	velocity = Vector2.ZERO
	GameState.lives -= 1
	play_animation("hit")
	_flash_damage()
	$Timer.start()

# Quick red flash for clear "took damage" feedback.
func _flash_damage():
	animated_sprite_2d.modulate = Color(1, 0.3, 0.3)
	var t = create_tween()
	t.tween_property(animated_sprite_2d, "modulate", Color(1, 1, 1), 0.3)

# After the hit animation has played briefly, either respawn (lives left) or show the death screen.
func _on_timer_timeout():
	if GameState.lives > 0:
		GameState.respawn()
	else:
		Transition.wipe(_show_death_screen)

func _show_death_screen():
	var screen = preload("res://scenes/DeathScreen.tscn").instantiate()
	get_tree().current_scene.add_child(screen)
	get_tree().paused = true
