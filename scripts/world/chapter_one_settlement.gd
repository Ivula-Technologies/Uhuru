extends Node2D

const NPC_SCRIPT := preload("res://scripts/npc/village_npc.gd")

var player: CharacterBody2D
var dialogue: DialoguePanel
var prompt: Label
var quest_panel: RichTextLabel
var completion_panel: PanelContainer
var dialogue_open := false

func _ready() -> void:
	QuestManager.load_quest_pack("res://data/quests/chapter_1_arrival.json")
	_build_environment()
	_build_player()
	_spawn_npcs()
	_build_hud()
	_build_dialogue()
	QuestManager.quest_completed.connect(_on_quest_completed)
	_refresh_quest_log()

func _build_environment() -> void:
	var sky := ColorRect.new()
	sky.color = Color("c58d63")
	sky.position = Vector2(-100, -100)
	sky.size = Vector2(1480, 900)
	add_child(sky)
	var ground := ColorRect.new()
	ground.color = Color("846f47")
	ground.position = Vector2(-100, 315)
	ground.size = Vector2(1480, 505)
	add_child(ground)
	for point in [Vector2(170, 235), Vector2(680, 180), Vector2(1110, 245)]:
		var tree := Polygon2D.new()
		tree.polygon = PackedVector2Array([point + Vector2(-62, 130), point + Vector2(0, -85), point + Vector2(62, 130)])
		tree.color = Color("304c35")
		add_child(tree)
	var road := Polygon2D.new()
	road.polygon = PackedVector2Array([Vector2(0, 570), Vector2(1280, 475), Vector2(1280, 550), Vector2(0, 645)])
	road.color = Color("b99b66")
	add_child(road)

func _build_player() -> void:
	player = preload("res://scenes/player/Player.tscn").instantiate()
	player.position = Vector2(220, 510)
	var label := Label.new()
	label.text = "You"
	label.position = Vector2(-20, -52)
	label.add_theme_font_size_override("font_size", 16)
	player.add_child(label)
	add_child(player)

func _spawn_npcs() -> void:
	var profiles: Array[Dictionary] = [
		{"id":"chapter1_guide", "display_name":"Community Guide", "contribution":"local memory", "color":"684838", "position":[430, 430], "dialogue":{"text":"We have heard of visitors asking about routes and land. Before we answer anyone, we must understand what their presence may mean for our families and neighbours.", "choices":[{"id":"ask_changes", "text":"What changes have you noticed?", "response":"New questions can carry new expectations. We will watch carefully and decide together how to respond."}]}},
		{"id":"chapter1_trader", "display_name":"Market Trader", "contribution":"exchange and news", "color":"3e5c69", "position":[760, 430], "dialogue":{"text":"More goods and stories are arriving along the paths. Exchange can be useful, but a price is not always written only in coins.", "choices":[{"id":"ask_trade", "text":"What has changed in trade?", "response":"People are comparing unfamiliar goods with the things they already make, grow and value."}]}},
		{"id":"chapter1_messenger", "display_name":"Messenger", "contribution":"news between communities", "color":"a55a51", "position":[1030, 420], "dialogue":{"text":"I carry news between communities. Some speak of surveyors and far-off plans. We share information so no one has to face uncertainty alone.", "choices":[{"id":"ask_news", "text":"What news should we remember?", "response":"Listen widely, verify what you hear, and make room for every family to be part of the conversation."}]}}
	]
	for profile in profiles:
		var npc: VillageNPC = NPC_SCRIPT.new()
		npc.setup(profile)
		var location: Array = profile.get("position", [0, 0])
		npc.position = Vector2(location[0], location[1])
		npc.interaction_requested.connect(_on_npc_interaction)
		add_child(npc)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 5
	add_child(layer)
	var bar := ColorRect.new()
	bar.color = Color("17251dcc")
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.offset_bottom = 88.0
	layer.add_child(bar)
	var title := Label.new()
	title.text = "CHAPTER 1 - The Arrival of Europeans"
	title.set_anchors_preset(Control.PRESET_TOP_LEFT)
	title.offset_left = 32.0
	title.offset_top = 16.0
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color("f4e7c7"))
	layer.add_child(title)
	prompt = Label.new()
	prompt.set_anchors_preset(Control.PRESET_TOP_LEFT)
	prompt.offset_left = 32.0
	prompt.offset_top = 52.0
	prompt.add_theme_color_override("font_color", Color("e7bb63"))
	layer.add_child(prompt)
	var help := Label.new()
	help.text = "WASD / Arrows: move | Shift: run | E: listen | Q: quest log | Esc: title"
	help.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	help.offset_left = 28.0
	help.offset_bottom = -18.0
	layer.add_child(help)
	quest_panel = RichTextLabel.new()
	quest_panel.bbcode_enabled = true
	quest_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	quest_panel.offset_left = -390.0
	quest_panel.offset_right = -32.0
	quest_panel.offset_top = 106.0
	quest_panel.offset_bottom = 360.0
	quest_panel.add_theme_font_size_override("normal_font_size", 16)
	layer.add_child(quest_panel)
	completion_panel = PanelContainer.new()
	completion_panel.set_anchors_preset(Control.PRESET_CENTER)
	completion_panel.offset_left = -310.0
	completion_panel.offset_right = 310.0
	completion_panel.offset_top = -180.0
	completion_panel.offset_bottom = 180.0
	completion_panel.visible = false
	completion_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	layer.add_child(completion_panel)
	var complete_box := VBoxContainer.new()
	complete_box.alignment = BoxContainer.ALIGNMENT_CENTER
	complete_box.add_theme_constant_override("separation", 18)
	completion_panel.add_child(complete_box)
	_add_label(complete_box, "CHAPTER 1 DEMO COMPLETE", 28, Color("e7bb63"))
	_add_label(complete_box, "You listened to how a community notices and discusses change together. The full Chapter 1 will expand these encounters through historically reviewed quests.", 18, Color.WHITE)
	var return_button := Button.new()
	return_button.text = "Return to Title Screen"
	return_button.custom_minimum_size = Vector2(280, 46)
	return_button.pressed.connect(func(): get_tree().paused = false; get_tree().change_scene_to_file("res://scenes/menus/TitleScreen.tscn"))
	complete_box.add_child(return_button)

func _build_dialogue() -> void:
	dialogue = DialoguePanel.new()
	dialogue.dialogue_finished.connect(func(): dialogue_open = false; get_tree().paused = false; player.movement_enabled = true)
	add_child(dialogue)

func _process(_delta: float) -> void:
	var nearby := _get_nearby_npc()
	prompt.text = "[E] Listen to " + nearby.profile.get("display_name", "villager") if nearby else "Explore the changing settlement."
	if nearby and not dialogue_open and Input.is_action_just_pressed("interact"):
		nearby.interact()
	if Input.is_action_just_pressed("quest_log"):
		quest_panel.visible = not quest_panel.visible
	if Input.is_key_pressed(KEY_ESCAPE) and not dialogue_open:
		get_tree().change_scene_to_file("res://scenes/menus/TitleScreen.tscn")

func _get_nearby_npc() -> VillageNPC:
	for node in get_tree().get_nodes_in_group("village_npc"):
		var npc := node as VillageNPC
		if npc and npc.player_near:
			return npc
	return null

func _on_npc_interaction(npc: VillageNPC) -> void:
	dialogue_open = true
	player.movement_enabled = false
	get_tree().paused = true
	var line: Dictionary = npc.profile.get("dialogue", {})
	dialogue.show_line(npc.profile.get("display_name", "Villager") + " - " + npc.profile.get("contribution", ""), line.get("text", ""), line.get("choices", []), Color(npc.profile.get("color", "684838")))
	QuestManager.evaluate_npc_visit(npc.npc_id)

func _on_quest_completed(quest_id: String) -> void:
	if quest_id == "chapter1_listen_to_changes":
		completion_panel.visible = true
		get_tree().paused = true
	_refresh_quest_log()

func _refresh_quest_log() -> void:
	var quest := QuestManager.get_quest("chapter1_listen_to_changes")
	quest_panel.text = "[b]CHAPTER 1 QUEST[/b]\n\n[b]" + quest.get("title", "") + "[/b]\n" + quest.get("narrative_goal", "") + "\n\n" + "\n".join(quest.get("objectives", []))

func _add_label(parent: Control, text_value: String, font_size: int, color: Color) -> void:
	var label := Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
