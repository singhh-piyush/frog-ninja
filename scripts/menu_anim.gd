class_name MenuAnim

# Reusable open/close animation for menus and overlays: fade the whole panel in/out
# and give the content a subtle scale "pop". Works while the tree is paused as long as
# the owning node has process_mode = ALWAYS (CanvasLayer overlays do).

static func open(root: CanvasItem, content: Control, dur := 0.15) -> void:
	await content.get_tree().process_frame   # let layout settle so content.size is valid
	root.modulate.a = 0.0
	content.pivot_offset = content.size / 2.0
	content.scale = Vector2(0.92, 0.92)
	var t := root.create_tween().set_parallel(true)
	t.tween_property(root, "modulate:a", 1.0, dur)
	t.tween_property(content, "scale", Vector2.ONE, dur) \
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

static func close(root: CanvasItem, dur := 0.12) -> Tween:
	var t := root.create_tween()
	t.tween_property(root, "modulate:a", 0.0, dur)
	return t
