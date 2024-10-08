extends RigidBody2D
class_name Player

const BULLET = preload("res://bullet.tscn")
@onready var ship_lines: Line2D = $ShipLines
@onready var engine_particles: CPUParticles2D = $ShipLines/EngineParticles
@onready var shield_restore_delay_timer: Timer = $ShieldRestoreDelayTimer
@onready var death_particles: CPUParticles2D = $DeathParticles

@onready var shield_vis: Sprite2D = $ShipLines/Shield
@onready var turret: Node2D = $Turret


var collision_pos : Vector2
var collision_impulse : Vector2



@export var thrust_power = 100
@export var turn_strength = 30
@export var max_bullets : int = 3
@export var fire_rate : float = 0.3
@export var shot_pellets : int = 1
@export var bullet_speed : float = 5
@export var shield_restore_delay : float = 2 :
	set(value):
		shield_restore_time = value
		shield_restore_delay_timer.wait_time = shield_restore_time
@export var shield_restore_time : float = 4


var level_up_xp : int = 10
var level : int = 0
var xp : int = 0

var shield : float = 100 :
	set(value):
		shield = value
		Hud.shield_bar.value = shield

var shield_max : float = 100

var spin : float = 0 :
	set(value):
		spin = clampf(value, -turn_strength, turn_strength)

var thrust : float
var brake : bool
var fire_cooldown : float = 0
var prev_pos : Vector2
var dead : bool = false

func _ready() -> void:
	Hud.player = self
	Hud.xp_bar.update(xp, level_up_xp)
	global_position = get_viewport_rect().get_center()

func _process(delta: float) -> void:
	if not dead:
		fire_cooldown -= delta
		engine_particles.emitting = false if brake else true
		thrust = inverse_lerp(0, thrust, 0.25)
		spin = lerpf(spin, 0, 5 * delta) if brake else lerpf(spin, 0, 20 * delta)
		if shield_restore_delay_timer.is_stopped():
			shield = lerpf(shield, shield_max, delta)
		if Input.is_action_pressed("fire"):
			if fire_bullets():
				Camera.shake(40, 3, 10, Vector2.from_angle(transform.get_rotation()))
		brake = Input.is_action_pressed("brake")
		thrust = Input.get_axis("throttle_down", "throttle_up") * thrust_power
		spin += Input.get_axis("left", "right")
	

func _physics_process(delta: float) -> void:
	constant_torque = spin * turn_strength
	if not brake:
		constant_force = Vector2(thrust, 0).rotated(transform.get_rotation())
	screen_wrap()
	
func fire_bullets() -> bool:
	if get_tree().get_node_count_in_group("player_bullets") < max_bullets and fire_cooldown < 0:
		fire_cooldown = fire_rate
		for i in range(shot_pellets):
			var bullet = BULLET.instantiate()
			bullet.speed = bullet_speed
			bullet.global_position = to_global(ship_lines.points[1])
			bullet.global_rotation = ship_lines.global_rotation
			bullet.xp_gain.connect(_on_xp_gain)
			if i > 1:
				bullet.global_rotation += randf_range(-.03, .03)
			get_parent().add_child(bullet)
		return true
	return false

func _integrate_forces(state) -> void:
	if state.get_contact_count() > 0:
		collision_pos = to_local(state.get_contact_local_position(0))
		collision_impulse = abs((state.get_contact_collider_velocity_at_position(0) \
		+ linear_velocity * (mass + state.get_contact_collider_object(0).mass)))

func screen_wrap():
	var screen_size = get_viewport_rect().size
	global_position.x = wrapf(global_position.x, 0, screen_size.x)
	global_position.y = wrapf(global_position.y, 0, screen_size.y)

func take_damage(damage : int, angle : float) -> void:
	if shield >= 0:
		var tween = get_tree().create_tween()
		tween.tween_property(shield_vis, "modulate:a", 0, 0.5).from(1)
		shield -= damage
		shield_restore_delay_timer.start()
	elif damage > 39:
		die()

func die() -> void:
	dead = true
	ship_lines.hide()
	death_particles.emitting = true
	
	await death_particles.finished
	queue_free()

func _on_xp_gain() -> void:
	xp += 1
	if xp > level_up_xp:
		level += 1
		xp = 0
		var new_level_xp_value : int = int(level * 0.1) + level_up_xp
		level_up_xp += new_level_xp_value
		prints("levelup", level_up_xp)
	Hud.xp_bar.update(xp, level_up_xp)

func _on_body_entered(body: Node) -> void:
	print(body.name)
	if body.is_in_group("asteroids"):
		var damage : int = clampi(int(collision_impulse.length() / 3), 0, 50)
		var angle : float = global_position.angle_to_point(collision_pos)
		take_damage(damage, angle)
