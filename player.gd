extends RigidBody2D
@onready var ship_lines: Line2D = $ShipLines
@onready var cpu_particles_2d: CPUParticles2D = $ShipLines/CPUParticles2D
const BULLET = preload("res://bullet.tscn")
@onready var aim_point: Marker2D = $ShipLines/AimPoint

@export var thrust_power = 100
@export var turn_strength = 18

var spin : float = 0 :
	set(value):
		spin = clampf(value, -turn_strength, turn_strength)

var thrust : float
var brake : bool
var fire_cooldown : float = 0
var prev_pos : Vector2

func _ready() -> void:
	global_position = get_viewport_rect().get_center()

func _process(delta: float) -> void:
	cpu_particles_2d.emitting = false if brake else true
	thrust = inverse_lerp(0, thrust, 0.25)
	spin = lerpf(spin, 0, delta) if brake else lerpf(spin, 0, 20 * delta)
	if Input.is_action_pressed("fire"):
		if get_tree().get_node_count_in_group("player_bullets") < 5 and fire_cooldown < 0:
			%Camera.shake(500, 1, .02, Vector2.from_angle(transform.get_rotation()))
			fire_cooldown = .3
			var bullet = BULLET.instantiate()
			bullet.global_position = aim_point.global_position
			bullet.global_rotation = ship_lines.global_rotation
			get_parent().add_child(bullet)
	fire_cooldown -= delta
	brake = Input.is_action_pressed("brake")
	thrust = Input.get_axis("throttle_down", "throttle_up") * thrust_power
	%Camera.shake(1500, thrust / thrust_power, .02, Vector2.from_angle(transform.get_rotation()))
	spin += Input.get_axis("left", "right")

func _physics_process(delta: float) -> void:
	
	constant_torque = spin * turn_strength
	if not brake:
		constant_force = Vector2(thrust, 0).rotated(transform.get_rotation())
	
	screen_wrap()

func screen_wrap():
	var screen_size = get_viewport_rect().size
	global_position.x = wrapf(global_position.x, 0, screen_size.x)
	global_position.y = wrapf(global_position.y, 0, screen_size.y)
