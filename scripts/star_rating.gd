class_name StarRating
extends RefCounted

# Shared per-level star rating, used by both the Level Complete popup and the Win screen.
# A level's coins decide its stars: collect >=1/3 -> 1 star, >=2/3 -> 2, all of them -> 3.
# `fill()` paints an HBoxContainer of TextureRect slots: earned slots show the gold star, the
# rest are dimmed to read as empty.

const STAR := preload("res://assets/Free/Items/Star.png")
const STAR_FRAME := Rect2(0, 0, 32, 32)  # first gold star in the sheet

static func earned(collected: int, total: int) -> int:
	var ratio := float(collected) / total if total > 0 else 0.0
	if ratio >= 1.0:
		return 3
	elif ratio >= 2.0 / 3.0:
		return 2
	elif ratio >= 1.0 / 3.0:
		return 1
	return 0

static func fill(box: HBoxContainer, collected: int, total: int) -> void:
	var n := earned(collected, total)
	for i in box.get_child_count():
		var star := box.get_child(i) as TextureRect
		var atlas := AtlasTexture.new()
		atlas.atlas = STAR
		atlas.region = STAR_FRAME
		star.texture = atlas
		star.modulate = Color(1, 1, 1) if i < n else Color(0.15, 0.15, 0.15, 0.55)
