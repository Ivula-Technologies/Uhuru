class_name DialoguePanel
extends CanvasLayer

signal dialogue_finished
signal choice_selected(choice: Dictionary)

var speaker_label: Label
var body_label: RichTextLabel
var choice_box: VBoxContainer
var panel: PanelContainer
var portrait: Label

func _ready() -> void:
	layer = 10
	panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.position = Vector2(70, -245)
	panel.size = Vector2(1140, 210)
	panel.visible = false
	add_child(panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	panel.add_child(row)
	portrait = Label.new()
	portrait.custom_minimum_size = Vector2(140, 150)
	portrait.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	portrait.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	portrait.add_theme_font_size_override("font_size", 22)
	row.add_child(portrait)
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 8)
	row.add_child(content)
	speaker_label = Label.new()
	speaker_label.add_theme_font_size_override("font_size", 24)
	content.add_child(speaker_label)
	body_label = RichTextLabel.new()
	body_label.custom_minimum_size.y = 90
	body_label.bbcode_enabled = true
	body_label.fit_content = true
	body_label.scroll_active = false
	body_label.add_theme_font_size_override("normal_font_size", 18)
	content.add_child(body_label)
	choice_box = VBoxContainer.new()
	content.add_child(choice_box)

func show_line(speaker: String, text_value: String, choices: Array = [], portrait_color := Color("684838")) -> void:
	panel.visible = true
	speaker_label.text = speaker
	body_label.text = text_value
	portrait.text = speaker
	portrait.add_theme_color_override("font_color", portrait_color)
	for child in choice_box.get_children():
		child.queue_free()
	if choices.is_empty():
		_add_choice("Continue", _finish)
		return
	for index in choices.size():
		var choice: Dictionary = choices[index]
		var choice_id: String = choice.get("id", "choice_" + str(index))
		choice["id"] = choice_id
		_add_choice(choice.get("text", "Continue"), _select_choice.bind(choice))

func _add_choice(text_value: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size.y = 30
	button.pressed.connect(callback)
	choice_box.add_child(button)

func _finish() -> void:
	panel.visible = false
	dialogue_finished.emit()

func _select_choice(choice: Dictionary) -> void:
	choice_selected.emit(choice)
	var response: String = choice.get("response", "")
	if response.is_empty():
		_finish()
		return
	body_label.text = response
	for child in choice_box.get_children():
		child.queue_free()
	_add_choice("Continue", _finish)
