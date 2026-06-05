extends TextureRect

# Plays the menu background as an animated loop. Godot 4 can't import animated GIFs, so
# assets/background.gif was coalesced into assets/menu_bg/frame_NN.png; this swaps the TextureRect's
# texture through them at the GIF's native 10 fps. Attached to the background of every menu screen.
# Overlay CanvasLayers run process_mode = ALWAYS (children inherit), so it animates while paused too.

const FRAME_DIR := "res://assets/menu_bg/"
const FPS := 10.0

var frames: Array[Texture2D] = []
var idx := 0
var accum := 0.0

func _ready() -> void:
	var dir := DirAccess.open(FRAME_DIR)
	if dir:
		var names := dir.get_files()
		names.sort()   # frame_00, frame_01, … in order
		for n in names:
			if n.begins_with("frame_") and n.ends_with(".png"):
				frames.append(load(FRAME_DIR + n))
	if not frames.is_empty():
		texture = frames[0]

func _process(delta: float) -> void:
	if frames.size() < 2:
		return
	accum += delta
	if accum >= 1.0 / FPS:
		accum = 0.0
		idx = (idx + 1) % frames.size()
		texture = frames[idx]
