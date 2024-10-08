extends Area2D

var speed : float = 5
var damage : int = 100
signal xp_gain
@onready var fire_sound: AudioStreamPlayer2D = $FireSound
@onready var collision_particles: CPUParticles2D = $CollisionParticles

func _ready() -> void:
	add_to_group("player_bullets")

func _physics_process(delta: float) -> void:
	global_position += Vector2.from_angle(rotation) * speed
	if global_position.x > get_viewport_rect().size.x \
	or global_position.y > get_viewport_rect().size.y \
	or global_position.y < 0 \
	or global_position.x < 0:
		die()



func _on_body_entered(body: Node2D) -> void:
	if body is Asteroid:
		body.take_damage(damage, rotation)
		xp_gain.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		collision_particles.emitting = true
		die()


func die() -> void:
	$Line2D.hide()
	
	if collision_particles.emitting:
		await collision_particles.finished
	if fire_sound.playing:
		await fire_sound.finished
	queue_free()
