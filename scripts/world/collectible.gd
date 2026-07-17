class_name Collectible
extends Area2D

signal interaction_requested(collectible: Collectible)

var profile: Dictionary = {}
var player_near := false

func setup(new_profile: Dictionary) -> void:
	profile = new_profile

func _ready() -> void:
	add_to_group("interactable")
	monitoring = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 48.0
	shape.shape = circle
	add_child(shape)
	var icon := Polygon2D.new()
	icon.polygon = PackedVector2Array([Vector2(0, -18), Vector2(18, 0), Vector2(0, 18), Vector2(-18, 0)])
	icon.color = Color(profile.get("color", "e7bb63"))
	add_child(icon)
	var label := Label.new()
	label.text = profile.get("display_name", "Object")
	label.position = Vector2(-50, 24)
	label.size = Vector2(100, 36)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 14)
	add_child(label)

func interact() -> void:
	interaction_requested.emit(self)

func collect() -> void:
	InventoryManager.add_item(profile.get("id", ""))
	SaveGame.add_journal_entry(profile.get("journal_entry", ""))
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
