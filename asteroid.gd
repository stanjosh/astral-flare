extends RigidBody2D
class_name Asteroid
@onready var line_2d: Line2D = $Line2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
var health : float = 100
func _ready() -> void:
	line_2d.points = collision_polygon_2d.polygon
	apply_central_force(Vector2(randfn(1000, 2000), 0).rotated(global_position.angle_to_point(get_viewport_rect().get_center())))


func _physics_process(delta: float) -> void:
	screen_wrap()

func screen_wrap():
	var screen_size = get_viewport_rect().size
	global_position.x = wrapf(global_position.x, -20, screen_size.x + 20)
	global_position.y = wrapf(global_position.y, -20, screen_size.y + 20)

func take_damage(damage : int, angle : float) -> void:
	if health - damage <= 0:

		var asteroid = self.duplicate(8)
		
		get_parent().add_child(asteroid)
		asteroid.collision_polygon_2d.scale = Vector2(0.5, 0.5)
		asteroid.line_2d.scale =  Vector2(0.5, 0.5)
		collision_polygon_2d.scale = Vector2(0.5, 0.5)
		line_2d.scale =  Vector2(0.5, 0.5)
	health -= damage
	apply_impulse(Vector2.from_angle(angle) * damage)
	
