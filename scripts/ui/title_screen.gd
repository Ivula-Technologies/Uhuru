extends Control

const GOLD := Color("e7bb63")
const DARK := Color("15231d")
var settings_panel: PanelContainer

func _ready() -> void:
	SaveGame.load_game()
	var bg := ColorRect.new()
	bg.color = DARK
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var land := ColorRect.new()
	land.color = Color("315b42")
	land.position = Vector2(0, 480)
	land.size = Vector2(1280, 240)
	add_child(land)
	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.position = Vector2(-270, -230)
	box.size = Vector2(540, 470)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(box)
	_add_label(box, "UHURU", 78, GOLD)
	_add_label(box, "EYES OF THE LAND", 23, Color("f4e7c7"))
	_add_label(box, "A journey through Kenya's living history", 17, Color("d9d0b9"))
	var spacer := Control.new(); spacer.custom_minimum_size.y = 35; box.add_child(spacer)
	_add_button(box, "Begin the Prologue", func(): get_tree().change_scene_to_file("res://scenes/world/PrologueVillage.tscn"))
	_add_button(box, "Settings", _show_settings)
	_add_button(box, "Exit", func(): get_tree().quit())
	_add_label(box, "Historical fiction • Educational adventure • Early development build", 13, Color("bdb49f"))

func _add_label(parent: Control, text_value: String, font_size: int, color: Color) -> void:
	var label := Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)

func _add_button(parent: Control, text_value: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(0, 52)
	button.add_theme_font_size_override("font_size", 20)
	button.pressed.connect(callback)
	parent.add_child(button)

func _show_settings() -> void:
	if settings_panel: settings_panel.queue_free()
	settings_panel = PanelContainer.new()
	settings_panel.set_anchors_preset(Control.PRESET_CENTER)
	settings_panel.position = Vector2(-220, -150)
	settings_panel.size = Vector2(440, 300)
	add_child(settings_panel)
	var box := VBoxContainer.new()
	settings_panel.add_child(box)
	_add_label(box, "SETTINGS", 30, GOLD)
	_add_label(box, "Music volume", 18, Color.WHITE)
	var volume := HSlider.new()
	volume.max_value = 100
	volume.value = SaveGame.data.settings.music_volume
	volume.value_changed.connect(func(value): SaveGame.data.settings.music_volume = value; AudioManager.set_music_volume(value); SaveGame.save_game())
	box.add_child(volume)
	_add_label(box, "Controls: WASD / arrows to move • Shift to run • E to interact", 15, Color.WHITE)
	_add_button(box, "Back", func(): settings_panel.queue_free(); settings_panel = null)
