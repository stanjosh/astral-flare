extends Camera2D


@export var shake_noise : FastNoiseLite = FastNoiseLite.new()
var noise_index : float = 0.0
@export var shake_speed : float = 0.0
@export var shake_strength : float = 0.0
@export var shake_decay : float = 0.0
@export var shake_angle : Vector2 = Vector2(0,0)

func get_shake_offset(delta : float) -> Vector2:
	noise_index += delta * shake_speed
	shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)
	#var random_offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	return Vector2(
		shake_noise.get_noise_2d(1, noise_index) * shake_strength,
		shake_noise.get_noise_2d(100, noise_index) * shake_strength
	) + shake_angle * shake_strength
	
func shake(speed : float = shake_speed, strength : float = shake_strength, decay : float = shake_decay, angle : Vector2 = Vector2(0,0)):
	shake_speed = speed
	shake_strength = strength
	shake_decay = decay
	shake_angle = angle

func _process(delta: float) -> void:
	offset = get_shake_offset(delta)
