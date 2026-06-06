extends Control

@onready var main_panel = $MainPanel
@onready var level_panel = $LevelSelectPanel
@onready var controls_panel = $ControlsPanel
@onready var sound_panel = $SoundPanel

@onready var master_slider = $SoundPanel/Layout/Card/VBox/MasterRow/MasterSlider
@onready var sfx_slider = $SoundPanel/Layout/Card/VBox/SFXRow/SFXSlider
@onready var music_slider = $SoundPanel/Layout/Card/VBox/MusicRow/MusicSlider

var switching = false

func _ready():
	main_panel.visible = true
	level_panel.visible = false
	controls_panel.visible = false
	sound_panel.visible = false
	MenuAnim.open(self, main_panel.get_node("Layout/Card"))

	# Apply default slider values to audio buses on startup.
	_apply_bus_volume("Master", master_slider.value)
	_apply_bus_volume("SFX", sfx_slider.value)
	_apply_bus_volume("Music", music_slider.value)

func _on_start_pressed():
	GameState.load_level(GameState.LEVELS[0], get_viewport().get_mouse_position())

func _on_level_select_pressed():
	await _swap(main_panel, level_panel)

func _on_back_pressed():
	await _swap(level_panel, main_panel)

func _on_controls_pressed():
	await _swap(main_panel, controls_panel)

func _on_controls_back_pressed():
	await _swap(controls_panel, main_panel)

func _on_sound_pressed():
	await _swap(main_panel, sound_panel)

func _on_sound_back_pressed():
	await _swap(sound_panel, main_panel)

func _on_exit_pressed():
	get_tree().quit()

func _swap(from_panel: Control, to_panel: Control):
	if switching:
		return
	switching = true
	await MenuAnim.close(from_panel).finished
	from_panel.visible = false
	to_panel.visible = true
	MenuAnim.open(to_panel, to_panel.get_node("Layout/Card"))
	switching = false

func _on_level_1_pressed():
	GameState.load_level("res://scenes/Level_1.tscn", get_viewport().get_mouse_position())

func _on_level_2_pressed():
	GameState.load_level("res://scenes/Level_2.tscn", get_viewport().get_mouse_position())

# ── Audio slider handlers ──────────────────────────────────────────────────────

func _on_master_slider_changed(value: float):
	_apply_bus_volume("Master", value)

func _on_sfx_slider_changed(value: float):
	_apply_bus_volume("SFX", value)

func _on_music_slider_changed(value: float):
	_apply_bus_volume("Music", value)

func _apply_bus_volume(bus_name: String, linear: float):
	var idx = AudioServer.get_bus_index(bus_name)
	if idx == -1:
		return
	if linear <= 0.0:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(linear))
