class_name PrologueComplete
extends CanvasLayer

signal continue_to_chapter_one

var panel: PanelContainer

func _ready() -> void:
	layer = 30
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -330.0
	panel.offset_right = 330.0
	panel.offset_top = -210.0
	panel.offset_bottom = 210.0
	panel.visible = false
	add_child(panel)
	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 18)
	panel.add_child(content)
	_add_label(content, "PROLOGUE COMPLETE", 30, Color("e7bb63"))
	_add_label(content, "You have listened to the many people whose work, knowledge and care sustain the village.", 20, Color("f4e7c7"))
	_add_label(content, "Before colonial rule, communities across Kenya had diverse traditions, economies and systems of governance. Their histories deserve to be understood on their own terms.", 17, Color.WHITE)
	_add_label(content, "Chapter 1 will explore how new arrivals begin to change familiar paths and relationships.", 17, Color("d9d0b9"))
	var continue_button := Button.new()
	continue_button.text = "Continue to Chapter 1"
	continue_button.custom_minimum_size = Vector2(300, 48)
	continue_button.pressed.connect(func(): continue_to_chapter_one.emit())
	content.add_child(continue_button)
	var title_button := Button.new()
	title_button.text = "Return to Title Screen"
	title_button.custom_minimum_size = Vector2(300, 42)
	title_button.pressed.connect(func(): get_tree().paused = false; get_tree().change_scene_to_file("res://scenes/menus/TitleScreen.tscn"))
	content.add_child(title_button)

func show_completion() -> void:
	panel.visible = true

func _add_label(parent: Control, text_value: String, font_size: int, color: Color) -> void:
	var label := Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
