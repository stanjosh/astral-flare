extends Sprite2D

var time : float = 100

func _ready() -> void:
	time = randf_range(-1000, 1000)

func _process(delta: float) -> void:
	time += delta
	get_material().set_shader_parameter("time", time / 10)
