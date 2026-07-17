class_name IntroCutscene
extends CanvasLayer

signal finished

var lines: Array = []
var index := 0
var text_label: Label
var panel: PanelContainer

func _ready() -> void:
	layer = 20
	panel = PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.visible = false
	add_child(panel)
	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 28)
	panel.add_child(content)
	var heading := Label.new()
	heading.text = "UHURU: EYES OF THE LAND"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 34)
	content.add_child(heading)
	text_label = Label.new()
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_label.custom_minimum_size = Vector2(760, 150)
	text_label.add_theme_font_size_override("font_size", 24)
	content.add_child(text_label)
	var continue_button := Button.new()
	continue_button.text = "Continue"
	continue_button.custom_minimum_size = Vector2(220, 48)
	continue_button.pressed.connect(_advance)
	content.add_child(continue_button)

func show_sequence(sequence: Array) -> void:
	lines = sequence
	index = 0
	panel.visible = true
	_show_current_line()

func _advance() -> void:
	index += 1
	if index >= lines.size():
		panel.visible = false
		finished.emit()
		return
	_show_current_line()

func _show_current_line() -> void:
	text_label.text = lines[index]
