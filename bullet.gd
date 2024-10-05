extends Area2D

var speed : float = 5

signal xp_gain

func _ready() -> void:
	add_to_group("player_bullets")

func _physics_process(delta: float) -> void:
	global_position += Vector2.from_angle(rotation) * speed
	if global_position.x > get_viewport_rect().size.x \
	or global_position.y > get_viewport_rect().size.y \
	or global_position.y < 0 \
	or global_position.x < 0:
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		body.take_damage(100, rotation)
		xp_gain.emit()
		queue_free()
