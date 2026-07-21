extends Node2D

const NPC_SCRIPT := preload("res://scripts/npc/village_npc.gd")
const COLLECTIBLE_SCRIPT := preload("res://scripts/world/collectible.gd")

var player: CharacterBody2D
var journal_panel: RichTextLabel
var quest_panel: RichTextLabel
var inventory_panel: RichTextLabel
var map_panel: RichTextLabel
var prompt: Label
var clock_label: Label
var save_status: Label
var world_tint: CanvasModulate
var dialogue: DialoguePanel
var prologue_complete: PrologueComplete
var pause_menu: PauseMenu
var dialogue_open := false
var nearby_npc: VillageNPC
var speaking_npc_id := ""
var intro_cutscene: IntroCutscene

func _ready() -> void:
	_build_environment()
	_build_world_boundaries()
	_build_player()
	_spawn_villagers()
	_spawn_collectibles()
	_build_hud()
	_build_dialogue()
	_build_completion_panel()
	_build_pause_menu()
	_build_intro_cutscene()
	QuestManager.quest_completed.connect(_on_quest_completed)
	InventoryManager.item_added.connect(_on_item_added)
	TimeOfDay.time_changed.connect(_on_time_changed)
	_on_time_changed(TimeOfDay.hour, TimeOfDay.get_phase())
	if QuestManager.get_active_quests().is_empty():
		call_deferred("_show_prologue_complete")
	if not SaveGame.has_seen_cutscene("prologue_arrival"):
		player.movement_enabled = false
		intro_cutscene.show_sequence([
			"Before borders, railways, and colonial rule, communities across this land shaped their own lives, traditions, and futures.",
			"At dawn, you wake in your village. The paths ahead begin with listening."
		])

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
	world_tint = CanvasModulate.new()
	world_tint.color = Color.WHITE
	add_child(world_tint)

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

func _spawn_collectibles() -> void:
	var file := FileAccess.open("res://data/collectibles/prologue.json", FileAccess.READ)
	var content: Dictionary = JSON.parse_string(file.get_as_text())
	for item in content.get("collectibles", []):
		var profile: Dictionary = item
		if InventoryManager.has_item(profile.get("id", "")):
			continue
		var collectible: Collectible = COLLECTIBLE_SCRIPT.new()
		collectible.setup(profile)
		var location: Array = profile.get("position", [0, 0])
		collectible.position = Vector2(location[0], location[1])
		collectible.interaction_requested.connect(_on_collectible_interaction_requested)
		add_child(collectible)

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
	layer.layer = 5
	add_child(layer)
	var bar := ColorRect.new()
	bar.color = Color("17251dcc")
	bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	bar.offset_bottom = 86.0
	layer.add_child(bar)
	var title := Label.new()
	title.text = "PROLOGUE - Before Colonial Rule"
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
	help.text = "WASD / Arrows: move | Shift: run | E: interact | J: journal | Q: quests | Esc: title"
	help.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	help.offset_left = 28.0
	help.offset_bottom = -18.0
	layer.add_child(help)
	clock_label = Label.new()
	clock_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	clock_label.offset_right = -32.0
	clock_label.offset_top = 26.0
	clock_label.add_theme_font_size_override("font_size", 20)
	layer.add_child(clock_label)
	save_status = Label.new()
	save_status.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	save_status.offset_right = -32.0
	save_status.offset_bottom = -18.0
	save_status.add_theme_color_override("font_color", Color("e7bb63"))
	layer.add_child(save_status)
	journal_panel = RichTextLabel.new()
	journal_panel.bbcode_enabled = true
	journal_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	journal_panel.offset_left = -390.0
	journal_panel.offset_right = -32.0
	journal_panel.offset_top = 106.0
	journal_panel.offset_bottom = 360.0
	journal_panel.visible = false
	journal_panel.add_theme_font_size_override("normal_font_size", 16)
	layer.add_child(journal_panel)
	quest_panel = RichTextLabel.new()
	quest_panel.bbcode_enabled = true
	quest_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	quest_panel.offset_left = -390.0
	quest_panel.offset_right = -32.0
	quest_panel.offset_top = 106.0
	quest_panel.offset_bottom = 360.0
	quest_panel.visible = false
	quest_panel.add_theme_font_size_override("normal_font_size", 16)
	layer.add_child(quest_panel)
	inventory_panel = RichTextLabel.new()
	inventory_panel.bbcode_enabled = true
	inventory_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	inventory_panel.offset_left = -390.0
	inventory_panel.offset_right = -32.0
	inventory_panel.offset_top = 106.0
	inventory_panel.offset_bottom = 360.0
	inventory_panel.visible = false
	inventory_panel.add_theme_font_size_override("normal_font_size", 16)
	layer.add_child(inventory_panel)
	map_panel = RichTextLabel.new()
	map_panel.bbcode_enabled = true
	map_panel.set_anchors_preset(Control.PRESET_CENTER)
	map_panel.offset_left = -290.0
	map_panel.offset_right = 290.0
	map_panel.offset_top = -180.0
	map_panel.offset_bottom = 180.0
	map_panel.visible = false
	map_panel.add_theme_font_size_override("normal_font_size", 20)
	map_panel.text = "[b]VILLAGE MAP[/b]\n\n        Hills and fields\n\n  Water path       Weaver\n\nYou     Elder       Homestead\n\n        Market path\n\n[yellow]M[/yellow] Close map"
	layer.add_child(map_panel)
	_refresh_journal()
	_refresh_quest_log()
	_refresh_inventory()

func _build_dialogue() -> void:
	dialogue = DialoguePanel.new()
	dialogue.dialogue_finished.connect(func():
		dialogue_open = false
		if not prologue_complete.panel.visible:
			pause_menu.can_open = true
			get_tree().paused = false
			player.movement_enabled = true
	)
	dialogue.choice_selected.connect(_on_dialogue_choice_selected)
	add_child(dialogue)

func _build_intro_cutscene() -> void:
	intro_cutscene = IntroCutscene.new()
	intro_cutscene.finished.connect(_on_intro_cutscene_finished)
	add_child(intro_cutscene)

func _build_completion_panel() -> void:
	prologue_complete = PrologueComplete.new()
	prologue_complete.continue_to_chapter_one.connect(func(): get_tree().paused = false; get_tree().change_scene_to_file("res://scenes/world/ChapterOneSettlement.tscn"))
	add_child(prologue_complete)

func _build_pause_menu() -> void:
	pause_menu = PauseMenu.new()
	add_child(pause_menu)

func _show_prologue_complete() -> void:
	if prologue_complete.panel.visible:
		return
	pause_menu.can_open = false
	get_tree().paused = true
	prologue_complete.show_completion()

func _process(_delta: float) -> void:
	nearby_npc = _get_nearby_npc()
	var nearby_collectible := _get_nearby_collectible()
	if nearby_npc:
		prompt.text = "[E] Speak with " + nearby_npc.profile.get("display_name", "villager")
	elif nearby_collectible:
		prompt.text = "[E] Collect " + nearby_collectible.profile.get("display_name", "object")
	else:
		prompt.text = "Explore the village."
	if nearby_npc and not dialogue_open and Input.is_action_just_pressed("interact"):
		nearby_npc.interact()
	elif nearby_collectible and not dialogue_open and Input.is_action_just_pressed("interact"):
		nearby_collectible.interact()
	if Input.is_action_just_pressed("journal"):
		journal_panel.visible = not journal_panel.visible
		quest_panel.visible = false
	if Input.is_action_just_pressed("quest_log"):
		quest_panel.visible = not quest_panel.visible
		journal_panel.visible = false
		inventory_panel.visible = false
	if Input.is_action_just_pressed("inventory"):
		inventory_panel.visible = not inventory_panel.visible
		journal_panel.visible = false
		quest_panel.visible = false
	if Input.is_action_just_pressed("map"):
		map_panel.visible = not map_panel.visible
		journal_panel.visible = false
		quest_panel.visible = false
		inventory_panel.visible = false
	if Input.is_key_pressed(KEY_F5):
		SaveGame.save_game()
		save_status.text = "Progress saved"

func _get_nearby_npc() -> VillageNPC:
	for node in get_tree().get_nodes_in_group("village_npc"):
		var npc := node as VillageNPC
		if npc.player_near:
			return npc
	return null

func _get_nearby_collectible() -> Collectible:
	for node in get_tree().get_nodes_in_group("interactable"):
		var collectible := node as Collectible
		if collectible and collectible.player_near:
			return collectible
	return null

func _on_npc_interaction_requested(npc: VillageNPC) -> void:
	dialogue_open = true
	player.movement_enabled = false
	pause_menu.can_open = false
	get_tree().paused = true
	speaking_npc_id = npc.npc_id
	var line: Dictionary = npc.profile.get("dialogue", {})
	var text_value: String = line.get("text", "")
	if SaveGame.get_relationship(npc.npc_id) > 0:
		text_value += "\n\nYou have listened with care before. The villager remembers."
	var contribution: String = npc.profile.get("contribution", "")
	var speaker := npc.profile.get("display_name", "Villager")
	if not contribution.is_empty():
		speaker += " - " + contribution
	dialogue.show_line(speaker, text_value, line.get("choices", []), Color(npc.profile.get("color", "684838")))
	var quest_id: String = npc.profile.get("quest_id", "")
	QuestManager.evaluate_npc_visit(npc.npc_id)
	if not quest_id.is_empty():
		QuestManager.complete_quest(quest_id)
	var journal_entry: String = npc.profile.get("journal_entry", "")
	if not journal_entry.is_empty():
		SaveGame.add_journal_entry(journal_entry)
		_refresh_journal()

func _on_collectible_interaction_requested(collectible: Collectible) -> void:
	collectible.collect()

func _on_item_added(_item_id: String) -> void:
	_refresh_inventory()
	_refresh_journal()
	_refresh_quest_log()

func _on_quest_completed(_quest_id: String) -> void:
	_refresh_journal()
	_refresh_quest_log()
	journal_panel.visible = true
	if QuestManager.get_active_quests().is_empty():
		_show_prologue_complete()

func _on_dialogue_choice_selected(choice: Dictionary) -> void:
	if not speaking_npc_id.is_empty():
		SaveGame.record_choice(speaking_npc_id, choice.get("id", ""))
		SaveGame.adjust_relationship(speaking_npc_id, int(choice.get("relationship_delta", 0)))
	speaking_npc_id = ""

func _on_intro_cutscene_finished() -> void:
	SaveGame.mark_cutscene_seen("prologue_arrival")
	player.movement_enabled = true

func _on_time_changed(_hour: float, phase: String) -> void:
	clock_label.text = TimeOfDay.get_clock_text() + "  " + phase.capitalize()
	match phase:
		"dawn":
			world_tint.color = Color("f0c59b")
		"day":
			world_tint.color = Color.WHITE
		"dusk":
			world_tint.color = Color("d59a91")
		"night":
			world_tint.color = Color("62719b")

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

func _refresh_inventory() -> void:
	var names: Dictionary = {}
	var file := FileAccess.open("res://data/collectibles/prologue.json", FileAccess.READ)
	var content: Dictionary = JSON.parse_string(file.get_as_text())
	for item in content.get("collectibles", []):
		names[item.get("id", "")] = item.get("display_name", "Object")
	var item_ids: Array = SaveGame.data.get("inventory", [])
	var lines: Array[String] = ["[b]INVENTORY[/b]"]
	if item_ids.is_empty():
		lines.append("\nNo objects collected yet.")
	else:
		for item_id in item_ids:
			lines.append("\n- " + names.get(item_id, item_id))
	inventory_panel.text = "\n".join(lines)
