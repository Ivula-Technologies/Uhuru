extends Node

signal quest_completed(quest_id: String)

const QUEST_DATA_PATH := "res://data/quests/prologue.json"
var quests: Dictionary = {}

func _ready() -> void:
	_load_quests()

func _load_quests() -> void:
	var file := FileAccess.open(QUEST_DATA_PATH, FileAccess.READ)
	if file == null:
		push_warning("Quest data was not found: " + QUEST_DATA_PATH)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		quests = parsed.get("quests", {})

func get_quest(quest_id: String) -> Dictionary:
	return quests.get(quest_id, {})

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
