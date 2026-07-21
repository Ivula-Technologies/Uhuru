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
		"choices": {},
		"relationships": {},
		"visited_npcs": [],
		"seen_cutscenes": [],
		"inventory": [],
		"settings": {"music_volume": 75.0, "text_speed": 1.0, "text_scale": 1.0}
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

func record_choice(choice_key: String, choice_id: String) -> void:
	var choices: Dictionary = data.get("choices", {})
	choices[choice_key] = choice_id
	data["choices"] = choices
	save_game()

func adjust_relationship(character_id: String, amount: int) -> void:
	var relationships: Dictionary = data.get("relationships", {})
	relationships[character_id] = int(relationships.get(character_id, 0)) + amount
	data["relationships"] = relationships
	save_game()

func get_relationship(character_id: String) -> int:
	return int(data.get("relationships", {}).get(character_id, 0))

func mark_npc_visited(npc_id: String) -> void:
	var visited: Array = data.get("visited_npcs", [])
	if not visited.has(npc_id):
		visited.append(npc_id)
		data["visited_npcs"] = visited
		save_game()

func has_visited_npc(npc_id: String) -> bool:
	return data.get("visited_npcs", []).has(npc_id)

func has_seen_cutscene(cutscene_id: String) -> bool:
	return data.get("seen_cutscenes", []).has(cutscene_id)

func mark_cutscene_seen(cutscene_id: String) -> void:
	var seen: Array = data.get("seen_cutscenes", [])
	if not seen.has(cutscene_id):
		seen.append(cutscene_id)
		data["seen_cutscenes"] = seen
		save_game()
