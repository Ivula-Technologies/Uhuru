extends Node

signal quest_completed(quest_id: String)

const QUEST_DATA_PATH := "res://data/quests/prologue.json"
var quests: Dictionary = {}

func _ready() -> void:
	_load_quests()

func _load_quests() -> void:
	load_quest_pack(QUEST_DATA_PATH)

func load_quest_pack(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Quest data was not found: " + path)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		for quest_id in parsed.get("quests", {}):
			quests[quest_id] = parsed["quests"][quest_id]

func get_quest(quest_id: String) -> Dictionary:
	return quests.get(quest_id, {})

func get_active_quests() -> Array:
	var active: Array = []
	for quest_id in quests:
		if not SaveGame.has_completed_quest(quest_id):
			active.append(quests[quest_id])
	return active

func complete_quest(quest_id: String) -> void:
	if SaveGame.has_completed_quest(quest_id):
		return
	var quest := get_quest(quest_id)
	if quest.is_empty():
		push_warning("Unknown quest: " + quest_id)
		return
	SaveGame.complete_quest(quest_id)
	SaveGame.add_journal_entry(quest.get("journal_entry", ""))
	quest_completed.emit(quest_id)

func evaluate_npc_visit(npc_id: String) -> void:
	SaveGame.mark_npc_visited(npc_id)
	evaluate_progress()

func evaluate_inventory() -> void:
	evaluate_progress()

func evaluate_progress() -> void:
	for quest_id in quests:
		var quest: Dictionary = quests[quest_id]
		if SaveGame.has_completed_quest(quest_id):
			continue
		if quest.get("required_npcs", []).is_empty() and quest.get("required_items", []).is_empty():
			continue
		var all_npcs_visited := true
		for required_npc in quest.get("required_npcs", []):
			if not SaveGame.has_visited_npc(required_npc):
				all_npcs_visited = false
				break
		var all_items_collected := true
		for item_id in quest.get("required_items", []):
			if not InventoryManager.has_item(item_id):
				all_items_collected = false
				break
		if all_npcs_visited and all_items_collected:
			complete_quest(quest_id)
