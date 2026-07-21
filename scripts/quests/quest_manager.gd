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
	for quest_id in quests:
		var quest: Dictionary = quests[quest_id]
		var required_npcs: Array = quest.get("required_npcs", [])
		if required_npcs.is_empty() or SaveGame.has_completed_quest(quest_id):
			continue
		var all_visited := true
		for required_npc in required_npcs:
			if not SaveGame.has_visited_npc(required_npc):
				all_visited = false
				break
		if all_visited:
			complete_quest(quest_id)

func evaluate_inventory() -> void:
	for quest_id in quests:
		var quest: Dictionary = quests[quest_id]
		var required_items: Array = quest.get("required_items", [])
		if required_items.is_empty() or SaveGame.has_completed_quest(quest_id):
			continue
		var all_collected := true
		for item_id in required_items:
			if not InventoryManager.has_item(item_id):
				all_collected = false
				break
		if all_collected:
			complete_quest(quest_id)
