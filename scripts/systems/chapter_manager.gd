extends Node

const CHAPTER_DATA_PATH := "res://data/chapters.json"
var chapters: Dictionary = {}

func _ready() -> void:
	var file := FileAccess.open(CHAPTER_DATA_PATH, FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Dictionary:
			chapters = parsed.get("chapters", {})

func is_unlocked(chapter_id: String) -> bool:
	var chapter: Dictionary = chapters.get(chapter_id, {})
	for quest_id in chapter.get("required_quests", []):
		if not SaveGame.has_completed_quest(quest_id):
			return false
	return not chapter.is_empty()

func enter_chapter(chapter_id: String) -> bool:
	if not is_unlocked(chapter_id):
		return false
	var chapter: Dictionary = chapters[chapter_id]
	SaveGame.data["chapter"] = chapter_id
	SaveGame.save_game()
	get_tree().change_scene_to_file(chapter.get("scene", ""))
	return true
