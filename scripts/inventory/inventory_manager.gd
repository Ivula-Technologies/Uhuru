extends Node

signal item_added(item_id: String)

func has_item(item_id: String) -> bool:
	return SaveGame.data.get("inventory", []).has(item_id)

func add_item(item_id: String) -> void:
	var inventory: Array = SaveGame.data.get("inventory", [])
	if inventory.has(item_id):
		return
	inventory.append(item_id)
	SaveGame.data["inventory"] = inventory
	SaveGame.save_game()
	item_added.emit(item_id)
	QuestManager.evaluate_inventory()
