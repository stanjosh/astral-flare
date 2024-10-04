extends Path2D
@onready var asteroids: Node2D = $Asteroids

@export var max_asteroids = 15

const ASTEROID = preload("res://asteroid.tscn")
func spawn():
	$PathFollow2D.progress_ratio = randf()
	var asteroid = ASTEROID.instantiate()
	asteroids.add_child(asteroid)
	asteroid.global_position = $PathFollow2D.global_position
	



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat"):
		spawn()


func _on_timer_timeout() -> void:
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	var asteroids_amount = asteroids \
	.map(func(a): return a.stage) \
	.reduce(func(a, b): return a + b)
	print(asteroids_amount)
	if asteroids_amount < max_asteroids:
		spawn()
