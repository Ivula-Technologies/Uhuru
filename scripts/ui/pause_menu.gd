class_name PauseMenu
extends CanvasLayer

var panel: PanelContainer
var escape_was_down := false
var can_open := true

func _ready() -> void:
	layer = 40
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -220.0
	panel.offset_right = 220.0
	panel.offset_top = -180.0
	panel.offset_bottom = 180.0
	panel.visible = false
	add_child(panel)
	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 14)
	panel.add_child(content)
	_add_label(content, "PAUSED", 30, Color("e7bb63"))
	_add_label(content, "The world is waiting for you.", 17, Color.WHITE)
	_add_button(content, "Resume", resume)
	_add_button(content, "Save Game", func(): SaveGame.save_game())
	_add_button(content, "Return to Title Screen", func(): get_tree().paused = false; get_tree().change_scene_to_file("res://scenes/menus/TitleScreen.tscn"))

func toggle() -> void:
	if not can_open and not panel.visible:
		return
	if panel.visible:
		resume()
	else:
		panel.visible = true
		get_tree().paused = true

func _process(_delta: float) -> void:
	var escape_is_down := Input.is_key_pressed(KEY_ESCAPE)
	if escape_is_down and not escape_was_down:
		toggle()
	escape_was_down = escape_is_down

func resume() -> void:
	panel.visible = false
	get_tree().paused = false

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
	button.custom_minimum_size = Vector2(270, 44)
	button.pressed.connect(callback)
	parent.add_child(button)
