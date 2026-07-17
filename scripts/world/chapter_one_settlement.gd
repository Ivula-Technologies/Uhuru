extends Node2D

func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color("6e9eb2")
	background.position = Vector2(-100, -100)
	background.size = Vector2(1480, 900)
	add_child(background)
	var title := Label.new()
	title.text = "CHAPTER 1 - The Arrival of Europeans\n\nFoundation scene: settlement, NPCs, and historically reviewed quests will be added here."
	title.position = Vector2(150, 220)
	title.size = Vector2(980, 220)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 28)
	add_child(title)
	var back := Button.new()
	back.text = "Return to Prologue"
	back.position = Vector2(520, 480)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/world/PrologueVillage.tscn"))
	add_child(back)
