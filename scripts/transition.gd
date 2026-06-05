extends CanvasLayer

# Autoload "Transition": a full-screen black circle-wipe between scenes. The circle grows from the
# click point until the screen is black (cover), the scene swaps, then an iris opens to reveal it.
# Runs with process_mode = ALWAYS so the cover animation plays even when an overlay paused the tree.
# `wipe()` reuses the same cover/reveal for in-scene pop-ups (pause menu, death, level complete):
# it covers, runs a caller-supplied action (toggle visibility / spawn overlay / set paused), reveals.

const DUR := 0.35
const MAX_RADIUS := 2.2   # enough to cover the far corner even when the circle starts at an edge

@onready var rect: ColorRect = $Wipe
@onready var mat: ShaderMaterial = $Wipe.material

var busy := false

func _ready() -> void:
	rect.visible = false

func change_scene(path: String, center_px := Vector2(-1, -1)) -> void:
	if busy:
		return
	busy = true
	await _cover(center_px)
	get_tree().paused = false
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await get_tree().process_frame
	await _reveal(center_px)
	busy = false

func reload_scene(center_px := Vector2(-1, -1)) -> void:
	if busy:
		return
	busy = true
	await _cover(center_px)
	get_tree().paused = false
	get_tree().reload_current_scene()
	await get_tree().process_frame
	await get_tree().process_frame
	await _reveal(center_px)
	busy = false

func wipe(action: Callable, center_px := Vector2(-1, -1)) -> void:
	if busy:
		return
	busy = true
	await _cover(center_px)
	action.call()   # toggle overlay visibility / spawn pop-up / set get_tree().paused
	await get_tree().process_frame
	await _reveal(center_px)
	busy = false

func _uv(center_px: Vector2) -> Vector2:
	var vp := get_viewport().get_visible_rect().size
	if center_px.x < 0.0:
		return Vector2(0.5, 0.5)
	return center_px / vp

func _cover(center_px: Vector2) -> void:
	var vp := get_viewport().get_visible_rect().size
	mat.set_shader_parameter("aspect", vp.x / vp.y)
	mat.set_shader_parameter("center", _uv(center_px))
	mat.set_shader_parameter("invert", 0.0)
	mat.set_shader_parameter("radius", 0.0)
	rect.visible = true
	var t := create_tween()
	t.tween_method(_set_radius, 0.0, MAX_RADIUS, DUR).set_ease(Tween.EASE_IN)
	await t.finished

func _reveal(center_px: Vector2) -> void:
	mat.set_shader_parameter("center", _uv(center_px))
	mat.set_shader_parameter("invert", 1.0)
	mat.set_shader_parameter("radius", 0.0)
	var t := create_tween()
	t.tween_method(_set_radius, 0.0, MAX_RADIUS, DUR).set_ease(Tween.EASE_OUT)
	await t.finished
	rect.visible = false

func _set_radius(r: float) -> void:
	mat.set_shader_parameter("radius", r)
