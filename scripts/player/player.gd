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
