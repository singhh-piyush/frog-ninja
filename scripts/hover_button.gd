extends Button

# Reusable menu button: shows an icon on the left and text on the right (Button default),
# the whole control is clickable, and it scales up slightly on hover/focus.

@export var hover_scale := 1.05

func _ready():
	_center_pivot()
	resized.connect(_center_pivot)
	mouse_entered.connect(func(): _scale_to(hover_scale))
	mouse_exited.connect(func(): _scale_to(1.0))
	focus_entered.connect(func(): _scale_to(hover_scale))
	focus_exited.connect(func(): _scale_to(1.0))

func _center_pivot():
	pivot_offset = size / 2.0

func _scale_to(s: float):
	create_tween().tween_property(self, "scale", Vector2.ONE * s, 0.08)

# Quick squash-and-settle pop, used for click feedback (e.g. the pause gear).
func bounce():
	_center_pivot()
	var t := create_tween()
	t.tween_property(self, "scale", Vector2.ONE * 1.2, 0.06)
	t.tween_property(self, "scale", Vector2.ONE, 0.12) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
