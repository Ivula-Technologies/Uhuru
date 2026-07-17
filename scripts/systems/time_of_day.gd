extends Node

signal time_changed(hour: float, phase: String)

@export var game_hours_per_second := 0.08
var hour := 6.0

func _process(delta: float) -> void:
	hour = fmod(hour + delta * game_hours_per_second, 24.0)
	time_changed.emit(hour, get_phase())

func get_phase() -> String:
	if hour < 6.0 or hour >= 19.0:
		return "night"
	if hour < 8.0:
		return "dawn"
	if hour < 17.0:
		return "day"
	return "dusk"

func get_clock_text() -> String:
	var display_hour := int(floor(hour))
	var minutes := int(floor((hour - display_hour) * 60.0))
	return "%02d:%02d" % [display_hour, minutes]
