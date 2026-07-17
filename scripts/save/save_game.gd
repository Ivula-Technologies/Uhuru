extends Node

const SAVE_PATH := "user://uhuru_save.json"
const CURRENT_VERSION := 1

var data: Dictionary = {}

func _ready() -> void:
	load_game()

func _default_data() -> Dictionary:
	return {
		"version": CURRENT_VERSION,
		"chapter": "prologue",
		"journal": ["You have arrived in the village at dawn."],
		"completed_quests": [],
		"settings": {"music_volume": 75.0, "text_speed": 1.0}
	}

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

func load_game() -> void:
	data = _default_data()
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		for key in parsed:
			data[key] = parsed[key]

func add_journal_entry(entry: String) -> void:
	var journal: Array = data.get("journal", [])
	if not journal.has(entry):
		journal.append(entry)
		data["journal"] = journal
		save_game()

func has_completed_quest(quest_id: String) -> bool:
	return data.get("completed_quests", []).has(quest_id)

func complete_quest(quest_id: String) -> void:
	var completed: Array = data.get("completed_quests", [])
	if not completed.has(quest_id):
		completed.append(quest_id)
		data["completed_quests"] = completed
		save_game()
