extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D

var jump_count = 0
var can_double_jump = true
var is_double_jumping = false

var current_animation = ""

func _ready():
	add_to_group("player")
	print("Player is ready and added to group 'player'")

func _physics_process(delta):
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
