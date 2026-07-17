extends Node2D

const NPC_SCRIPT := preload("res://scripts/npc/village_npc.gd")

var player: CharacterBody2D
var journal_panel: RichTextLabel
var quest_panel: RichTextLabel
var prompt: Label
var dialogue: DialoguePanel
var dialogue_open := false
var nearby_npc: VillageNPC
var speaking_npc_id := ""

func _ready() -> void:
	_build_environment()
	_build_world_boundaries()
	_build_player()
	_spawn_villagers()
	_build_hud()
	_build_dialogue()
	QuestManager.quest_completed.connect(_on_quest_completed)

func _build_environment() -> void:
	var sky := ColorRect.new()
	sky.color = Color("78aec2")
	sky.position = Vector2(-100, -100)
	sky.size = Vector2(1480, 900)
	add_child(sky)
	var grass := ColorRect.new()
	grass.color = Color("6f9b51")
	grass.position = Vector2(-100, 315)
	grass.size = Vector2(1480, 505)
	add_child(grass)
	for point in [Vector2(175, 230), Vector2(615, 185), Vector2(1060, 235)]:
		var tree := Polygon2D.new()
		tree.polygon = PackedVector2Array([point + Vector2(-58, 120), point + Vector2(0, -80), point + Vector2(58, 120)])
		tree.color = Color("28513b")
		add_child(tree)
	var hut := Polygon2D.new()
	hut.polygon = PackedVector2Array([Vector2(780, 450), Vector2(1080, 450), Vector2(1035, 570), Vector2(825, 570), Vector2(930, 330)])
	hut.color = Color("a4643e")
	add_child(hut)

func _build_world_boundaries() -> void:
	_add_wall(Vector2(640, 76), Vector2(1280, 32))
	_add_wall(Vector2(640, 704), Vector2(1280, 32))
	_add_wall(Vector2(16, 390), Vector2(32, 628))
	_add_wall(Vector2(1264, 390), Vector2(32, 628))

func _add_wall(location: Vector2, wall_size: Vector2) -> void:
	var wall := StaticBody2D.new()
	wall.position = location
	var collider := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = wall_size
	collider.shape = rectangle
	wall.add_child(collider)
	add_child(wall)

func _spawn_villagers() -> void:
	var file := FileAccess.open("res://data/npcs/prologue.json", FileAccess.READ)
	var content: Dictionary = JSON.parse_string(file.get_as_text())
	for item in content.get("npcs", []):
		var profile: Dictionary = item
		var npc: VillageNPC = NPC_SCRIPT.new()
		npc.setup(profile)
		var location: Array = profile.get("position", [0, 0])
		npc.position = Vector2(location[0], location[1])
		npc.interaction_requested.connect(_on_npc_interaction_requested)
		add_child(npc)

func _build_player() -> void:
	player = preload("res://scenes/player/Player.tscn").instantiate()
	player.position = Vector2(220, 530)
	var marker := Label.new()
	marker.text = "You"
	marker.position = Vector2(-18, -38)
	marker.add_theme_font_size_override("font_size", 18)
	player.add_child(marker)
	add_child(player)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var bar := ColorRect.new()
	bar.color = Color("17251dcc")
	bar.size = Vector2(1280, 85)
	layer.add_child(bar)
	var title := Label.new()
	title.text = "PROLOGUE - Before Colonial Rule"
	title.position = Vector2(32, 18)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color("f4e7c7"))
	layer.add_child(title)
	prompt = Label.new()
	prompt.position = Vector2(32, 52)
	prompt.add_theme_color_override("font_color", Color("e7bb63"))
	layer.add_child(prompt)
	var help := Label.new()
	help.text = "WASD / Arrows: move   Shift: run   E: interact   J: journal   Esc: title"
	help.position = Vector2(28, 680)
	layer.add_child(help)
	journal_panel = RichTextLabel.new()
	journal_panel.bbcode_enabled = true
	journal_panel.position = Vector2(890, 105)
	journal_panel.size = Vector2(350, 245)
	journal_panel.visible = false
	journal_panel.add_theme_font_size_override("normal_font_size", 16)
	layer.add_child(journal_panel)
	quest_panel = RichTextLabel.new()
	quest_panel.bbcode_enabled = true
	quest_panel.position = Vector2(890, 105)
	quest_panel.size = Vector2(350, 245)
	quest_panel.visible = false
	quest_panel.add_theme_font_size_override("normal_font_size", 16)
	layer.add_child(quest_panel)
	_refresh_journal()
	_refresh_quest_log()

func _build_dialogue() -> void:
	dialogue = DialoguePanel.new()
	dialogue.dialogue_finished.connect(func(): dialogue_open = false; player.movement_enabled = true)
	dialogue.choice_selected.connect(_on_dialogue_choice_selected)
	add_child(dialogue)

func _process(_delta: float) -> void:
	nearby_npc = _get_nearby_npc()
	prompt.text = "[E] Speak with " + nearby_npc.profile.get("display_name", "villager") if nearby_npc else "Explore the village."
	if nearby_npc and not dialogue_open and Input.is_action_just_pressed("interact"):
		nearby_npc.interact()
	if Input.is_action_just_pressed("journal"):
		journal_panel.visible = not journal_panel.visible
		quest_panel.visible = false
	if Input.is_action_just_pressed("quest_log"):
		quest_panel.visible = not quest_panel.visible
		journal_panel.visible = false
	if Input.is_key_pressed(KEY_ESCAPE) and not dialogue_open:
		get_tree().change_scene_to_file("res://scenes/menus/TitleScreen.tscn")

func _get_nearby_npc() -> VillageNPC:
	for node in get_tree().get_nodes_in_group("village_npc"):
		var npc := node as VillageNPC
		if npc.player_near:
			return npc
	return null

func _on_npc_interaction_requested(npc: VillageNPC) -> void:
	dialogue_open = true
	player.movement_enabled = false
	speaking_npc_id = npc.npc_id
	var line: Dictionary = npc.profile.get("dialogue", {})
	dialogue.show_line(npc.profile.get("display_name", "Villager"), line.get("text", ""), line.get("choices", []), Color(npc.profile.get("color", "684838")))
	var quest_id: String = npc.profile.get("quest_id", "")
	if not quest_id.is_empty():
		QuestManager.complete_quest(quest_id)
	var journal_entry: String = npc.profile.get("journal_entry", "")
	if not journal_entry.is_empty():
		SaveGame.add_journal_entry(journal_entry)
		_refresh_journal()

func _on_quest_completed(_quest_id: String) -> void:
	_refresh_journal()
	_refresh_quest_log()
	journal_panel.visible = true

func _on_dialogue_choice_selected(choice_id: String) -> void:
	if not speaking_npc_id.is_empty():
		SaveGame.record_choice(speaking_npc_id, choice_id)
	speaking_npc_id = ""

func _refresh_journal() -> void:
	var entries: Array = SaveGame.data.get("journal", [])
	journal_panel.text = "[b]JOURNAL & CODEX[/b]\n\n" + "\n\n".join(entries)

func _refresh_quest_log() -> void:
	var active: Array = QuestManager.get_active_quests()
	if active.is_empty():
		quest_panel.text = "[b]QUEST LOG[/b]\n\nNo active quests. Explore the village and speak with its people."
		return
	var lines: Array[String] = ["[b]QUEST LOG[/b]"]
	for quest: Dictionary in active:
		lines.append("\n[b]" + quest.get("title", "Quest") + "[/b]\n" + quest.get("narrative_goal", ""))
		for objective in quest.get("objectives", []):
			lines.append("- " + objective)
	quest_panel.text = "\n".join(lines)
