extends Control

const GOLD := Color("e7bb63")
const DARK := Color("15231d")
var settings_panel: PanelContainer
var save_panel: PanelContainer

func _ready() -> void:
	SaveGame.load_game()
	var background_art := TextureRect.new()
	background_art.texture = load("res://assets/reference/backgrounds/main_menu_concept.png")
	background_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background_art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background_art)
	var bg := ColorRect.new()
	bg.color = Color("15231d88")
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
	var logo := TextureRect.new()
	logo.texture = load("res://assets/reference/ui/game_logo.png")
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo.custom_minimum_size = Vector2(0, 190)
	box.add_child(logo)
	_add_label(box, "A journey through Kenya's living history", 17, Color("d9d0b9"))
	var spacer := Control.new(); spacer.custom_minimum_size.y = 35; box.add_child(spacer)
	_add_button(box, "Play / Save Slots", _show_save_slots)
	_add_button(box, "Settings", _show_settings)
	_add_button(box, "Exit", func(): get_tree().quit())
	_add_label(box, "Historical fiction | Educational adventure | Hackathon vertical slice", 13, Color("bdb49f"))

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
	_add_label(box, "Dialogue text size", 18, Color.WHITE)
	var text_scale := HSlider.new()
	text_scale.min_value = 80
	text_scale.max_value = 150
	text_scale.value = float(SaveGame.data.settings.get("text_scale", 1.0)) * 100.0
	text_scale.value_changed.connect(func(value): SaveGame.data.settings.text_scale = value / 100.0; SaveGame.save_game())
	box.add_child(text_scale)
	_add_label(box, "Controls: WASD / arrows to move | Shift to run | E to interact", 15, Color.WHITE)
	_add_button(box, "Back", func(): settings_panel.queue_free(); settings_panel = null)

func _show_save_slots() -> void:
	if save_panel:
		save_panel.queue_free()
	save_panel = PanelContainer.new()
	save_panel.set_anchors_preset(Control.PRESET_CENTER)
	save_panel.offset_left = -290.0
	save_panel.offset_right = 290.0
	save_panel.offset_top = -250.0
	save_panel.offset_bottom = 250.0
	add_child(save_panel)
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 12)
	save_panel.add_child(box)
	_add_label(box, "CHOOSE A SAVE SLOT", 28, GOLD)
	_add_label(box, "Choose Continue for an existing journey or Fresh Start for a new one.", 16, Color.WHITE)
	for slot in range(1, SaveGame.MAX_SLOTS + 1):
		var continue_button := Button.new()
		continue_button.text = "Continue: " + SaveGame.get_slot_summary(slot)
		continue_button.disabled = not SaveGame.slot_exists(slot)
		continue_button.custom_minimum_size = Vector2(0, 42)
		continue_button.pressed.connect(_continue_from_slot.bind(slot))
		box.add_child(continue_button)
		var new_button := Button.new()
		new_button.text = "Fresh Start in Slot " + str(slot)
		new_button.custom_minimum_size = Vector2(0, 36)
		new_button.pressed.connect(_start_new_slot.bind(slot))
		box.add_child(new_button)
	_add_button(box, "Back", func(): save_panel.queue_free(); save_panel = null)

func _continue_from_slot(slot: int) -> void:
	SaveGame.select_slot(slot)
	var chapter_id := str(SaveGame.data.get("chapter", "prologue"))
	var scene := "res://scenes/world/ChapterOneSettlement.tscn" if chapter_id == "chapter_1" else "res://scenes/world/PrologueVillage.tscn"
	get_tree().change_scene_to_file(scene)

func _start_new_slot(slot: int) -> void:
	SaveGame.start_new_game(slot)
	get_tree().change_scene_to_file("res://scenes/world/PrologueVillage.tscn")
