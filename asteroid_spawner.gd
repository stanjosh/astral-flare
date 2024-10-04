extends Path2D
@onready var asteroids: Node2D = $Asteroids

const ASTEROID = preload("res://asteroid.tscn")
func spawn():
	$PathFollow2D.progress_ratio = randf()
	var asteroid = ASTEROID.instantiate()
	asteroids.add_child(asteroid)
	asteroid.global_position = $PathFollow2D.global_position
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cheat"):
		spawn()
