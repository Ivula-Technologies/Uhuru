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
	monitoring = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
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
	body.polygon = PackedVector2Array([Vector2(-18, 28), Vector2(-14, -18), Vector2(14, -18), Vector2(18, 28)])
	body.color = Color(profile.get("color", "8e5039"))
	add_child(body)

func interact() -> void:
	interaction_requested.emit(self)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
