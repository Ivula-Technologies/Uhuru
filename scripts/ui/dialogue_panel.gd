class_name DialoguePanel
extends CanvasLayer

signal dialogue_finished

var speaker_label: Label
var body_label: RichTextLabel
var choice_box: VBoxContainer
var panel: PanelContainer

func _ready() -> void:
	layer = 10
	panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.position = Vector2(70, -245)
	panel.size = Vector2(1140, 210)
	panel.visible = false
	add_child(panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	panel.add_child(content)
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

func show_line(speaker: String, text_value: String, choices: Array = []) -> void:
	panel.visible = true
	speaker_label.text = speaker
	body_label.text = text_value
	for child in choice_box.get_children():
		child.queue_free()
	if choices.is_empty():
		_add_choice("Continue", _finish)
		return
	for choice in choices:
		_add_choice(choice.get("text", "Continue"), _finish)

func _add_choice(text_value: String, callback: Callable) -> void:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size.y = 30
	button.pressed.connect(callback)
	choice_box.add_child(button)

func _finish() -> void:
	panel.visible = false
	dialogue_finished.emit()
