class_name PopupWipe

# Reveals / conceals an in-game popup (pause, death, win, level-complete) with the same circle
# motion as the scene-change Transition — but instead of covering the screen to black, the popup's
# own `Dim` ColorRect irises in from a point, painting a *translucent* dim over the still-visible,
# frozen game. The themed card then pops in (MenuAnim). Works while paused because the owning
# overlays run process_mode = ALWAYS.
#
# `dim` must be a ColorRect whose material is a ShaderMaterial using shaders/circle_wipe.gdshader
# with a translucent `tint` (e.g. Color(0,0,0,0.5)). `center_px` is the click point in viewport
# pixels; a negative x falls back to screen centre (for death/win, which have no click origin).

const DUR := 0.3
const MAX_RADIUS := 2.2   # enough to cover the far corner even from a screen edge

static func reveal(dim: ColorRect, card: Control, center_px := Vector2(-1, -1)) -> void:
	var mat := dim.material as ShaderMaterial
	var vp := dim.get_viewport().get_visible_rect().size
	mat.set_shader_parameter("aspect", vp.x / vp.y)
	mat.set_shader_parameter("center", _uv(center_px, vp))
	mat.set_shader_parameter("invert", 0.0)
	mat.set_shader_parameter("radius", 0.0)
	dim.visible = true
	card.visible = false
	var t := dim.create_tween()
	t.tween_method(func(r): mat.set_shader_parameter("radius", r), 0.0, MAX_RADIUS, DUR) \
		.set_ease(Tween.EASE_OUT)
	await t.finished
	card.visible = true
	MenuAnim.open(card, card)

static func conceal(dim: ColorRect, card: Control, center_px := Vector2(-1, -1)) -> Tween:
	var mat := dim.material as ShaderMaterial
	var vp := dim.get_viewport().get_visible_rect().size
	mat.set_shader_parameter("center", _uv(center_px, vp))
	mat.set_shader_parameter("invert", 0.0)
	MenuAnim.close(card)   # card fades out while the dim irises closed
	var t := dim.create_tween()
	t.tween_method(func(r): mat.set_shader_parameter("radius", r), MAX_RADIUS, 0.0, DUR) \
		.set_ease(Tween.EASE_IN)
	return t

static func _uv(center_px: Vector2, vp: Vector2) -> Vector2:
	if center_px.x < 0.0:
		return Vector2(0.5, 0.5)
	return center_px / vp
