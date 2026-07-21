extends CharacterBody2D

@export var walk_speed := 220.0
@export var run_speed := 340.0
var movement_enabled := true

func _physics_process(_delta: float) -> void:
	if not movement_enabled:
		velocity = Vector2.ZERO
		return
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * (run_speed if Input.is_key_pressed(KEY_SHIFT) else walk_speed)
	move_and_slide()

func _ready() -> void:
	add_to_group("player")
	z_index = 3
	var shadow := Polygon2D.new()
	shadow.polygon = PackedVector2Array([Vector2(-18, 20), Vector2(18, 20), Vector2(24, 27), Vector2(-24, 27)])
	shadow.color = Color("1b241b66")
	add_child(shadow)
	var body := Polygon2D.new()
	body.polygon = PackedVector2Array([Vector2(-15, 20), Vector2(-11, -6), Vector2(11, -6), Vector2(15, 20)])
	body.color = Color("e2c18e")
	add_child(body)
	var sash := Polygon2D.new()
	sash.polygon = PackedVector2Array([Vector2(-12, -5), Vector2(-5, -5), Vector2(12, 20), Vector2(5, 20)])
	sash.color = Color("6a472d")
	add_child(sash)
	var head := Polygon2D.new()
	head.polygon = PackedVector2Array([Vector2(-10, -22), Vector2(0, -28), Vector2(10, -22), Vector2(9, -9), Vector2(0, -4), Vector2(-9, -9)])
	head.color = Color("71482f")
	add_child(head)
