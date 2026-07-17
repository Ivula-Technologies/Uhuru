extends Node

func _ready() -> void:
	set_music_volume(float(SaveGame.data.get("settings", {}).get("music_volume", 75.0)))

func set_music_volume(percent: float) -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(percent / 100.0, 0.001)))
	AudioServer.set_bus_mute(bus_index, percent <= 0.0)
