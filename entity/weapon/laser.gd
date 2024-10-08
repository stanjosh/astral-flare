extends Weapon


var heat : float = 100
var max_heat : float = 100

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var indicator_sprite: Sprite2D = $IndicatorSprite
@onready var barrel_line: Line2D = $BarrelLine
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var laser_line: Line2D = $LaserLine
@onready var damage_timer: Timer = $DamageTimer

@export var damage : float = 120

func _physics_process(delta: float) -> void:
	
	cpu_particles_2d.hide()
	laser_line.hide()
	if is_instance_valid(target):
		look_at(target.global_position)
		ray_cast_2d.target_position = to_local(target.global_position)
		if ray_cast_2d.is_colliding():
			cpu_particles_2d.global_position = ray_cast_2d.get_collision_point()
			cpu_particles_2d.show()
			laser_line.points[1] = to_local(ray_cast_2d.get_collision_point())
			laser_line.show()
			if damage_timer.is_stopped():
				var hit_object = ray_cast_2d.get_collider()
				if hit_object is Asteroid:
					print("asteroid")
					hit_object.take_damage(damage, ray_cast_2d.get_collision_normal().angle())
					damage_timer.start()



func set_color(color: Color) -> void:
	laser_line.modulate = color
	cpu_particles_2d.modulate = color

func cooloff() -> void:
	heat = lerp(heat, max_heat, 0.05)
