extends RigidBody2D
class_name Asteroid
@onready var line_2d: Line2D = $Line2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var death_particles: CPUParticles2D = $DeathParticles
@onready var collision_particles: CPUParticles2D = $CollisionParticles

var stage : int = 3
var health = 100 * stage
var collision_pos : Vector2 = Vector2.ZERO
var rumble : bool

func _ready() -> void:
	size_to_stage()
	apply_central_force(Vector2(randfn(1000, 500), randfn(1000, 500)))

func _process(delta: float) -> void:
	if rumble:
		Camera.shake(1000, stage, 1.2)

func _physics_process(delta: float) -> void:
	screen_wrap()

func screen_wrap():
	var screen_size = get_viewport_rect().size
	global_position.x = wrapf(global_position.x, -30, screen_size.x + 30)
	global_position.y = wrapf(global_position.y, -30, screen_size.y + 30)

func take_damage(damage : int = 1, angle : float = 0) -> void:
	prints(damage)
	collision_particles.emitting = true
	health -= damage
	if health <= 0:
		stage -= 1
		if stage <= 0:
			call_deferred("die")
		else:
			size_to_stage()
			for i in range(stage):
				var asteroid = self.duplicate(8)
				asteroid.stage = stage
				asteroid.health = health
				if asteroid.stage > 0:
					get_parent().call_deferred("add_child", asteroid)
					asteroid.global_position.y = global_position.y + randf() * 20
					asteroid.global_position.x = global_position.x + randf() * 20
			apply_impulse(Vector2.from_angle(angle) * damage)

	

func _integrate_forces(state) -> void:
	if state.get_contact_count() > 0:
		collision_pos = to_local(state.get_contact_local_position(0))

func size_to_stage():
	line_2d.points = collision_polygon_2d.polygon
	mass = float(stage)
	health = 100 * stage
	collision_polygon_2d.scale = Vector2.ONE * stage * .66
	line_2d.scale =  Vector2.ONE * stage * .66


func die():
	death_particles.position = collision_pos
	death_particles.emitting = true
	collision_polygon_2d.disabled = true
	line_2d.hide()
	await death_particles.finished
	queue_free()

func _on_body_entered(body: Node) -> void:
	rumble = true
	if stage > 0 and body.is_in_group("asteroids") and body.stage > 0:
		if linear_velocity.length() > 100 / stage:
			if body.stage <= stage:
				body.take_damage(0, get_angle_to(body.global_position))
	collision_particles.direction = global_position.direction_to(body.global_position)
	collision_particles.position = collision_pos
	collision_particles.scale = stage * Vector2.ONE
	collision_particles.initial_velocity_max = body.linear_velocity.length()
	collision_particles.emitting = true

func _on_body_exited(body: Node) -> void:
	rumble = false
