class_name VillageNPC
extends Area2D

signal interaction_requested(npc: VillageNPC)

var npc_id := ""
var profile: Dictionary = {}
var player_near := false

func setup(new_profile: Dictionary) -> void:
	profile = new_profile
	npc_id = profile.get("id", "")

func _ready() -> void:
	add_to_group("village_npc")
	add_to_group("interactable")
	monitoring = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	TimeOfDay.time_changed.connect(_on_time_changed)
	_apply_schedule(TimeOfDay.get_phase())
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 74.0
	shape.shape = circle
	add_child(shape)
	var marker := Label.new()
	marker.text = profile.get("display_name", "Villager")
	marker.position = Vector2(-55, -46)
	marker.size = Vector2(110, 42)
	marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	marker.add_theme_font_size_override("font_size", 16)
	marker.add_theme_color_override("font_color", Color("372a23"))
	add_child(marker)
	var body := Polygon2D.new()
	body.polygon = PackedVector2Array([Vector2(-18, 28), Vector2(-13, -11), Vector2(13, -11), Vector2(18, 28)])
	body.color = Color(profile.get("color", "8e5039"))
	add_child(body)
	var head := Polygon2D.new()
	head.polygon = PackedVector2Array([Vector2(-10, -28), Vector2(0, -34), Vector2(10, -28), Vector2(9, -14), Vector2(0, -9), Vector2(-9, -14)])
	head.color = Color("70482f")
	add_child(head)
	var contribution := Label.new()
	contribution.text = profile.get("contribution", "")
	contribution.position = Vector2(-70, 30)
	contribution.size = Vector2(140, 30)
	contribution.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	contribution.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	contribution.add_theme_font_size_override("font_size", 11)
	contribution.add_theme_color_override("font_color", Color("f5e7c3"))
	add_child(contribution)

func interact() -> void:
	interaction_requested.emit(self)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false

func _on_time_changed(_hour: float, phase: String) -> void:
	_apply_schedule(phase)

func _apply_schedule(phase: String) -> void:
	var schedule: Dictionary = profile.get("schedule", {})
	var destination: Array = schedule.get(phase, [])
	if destination.size() == 2:
		position = Vector2(destination[0], destination[1])
