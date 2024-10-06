extends Path2D
@onready var asteroids: Node2D = $Asteroids

@export var max_asteroids = 15

const ASTEROID = preload("res://entity/asteroid.tscn")
func spawn():
	$PathFollow2D.progress_ratio = randf()
	var asteroid = ASTEROID.instantiate()
	asteroids.add_child(asteroid)
	asteroid.global_position = $PathFollow2D.global_position
	



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat"):
		spawn()


func _on_timer_timeout() -> void:
	var asteroids = get_tree().get_node_count_in_group("asteroids")
	if asteroids < max_asteroids:
		spawn()
