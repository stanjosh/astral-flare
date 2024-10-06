extends Sprite2D

var time : float = 100
var direction : Vector2
var speed : float = 15
var colorval1 : float = 0.15
var colorval2 : float = 0.05
var colorval3 : float = 0.20
var color_timer : Timer = Timer.new()

func _ready() -> void:
	time = randf_range(-1000, 1000)
	speed = randf_range(10, 20)
	direction = Vector2.from_angle(randf())
	color_timer.timeout.connect(rand_colors)
	add_child(color_timer)
	rand_colors()

func _process(delta: float) -> void:
	time += delta
	get_material().set_shader_parameter("mouse", direction * speed)
	get_material().set_shader_parameter("time", time / 10)
	get_material().set_shader_parameter("colorval1", colorval1)
	get_material().set_shader_parameter("colorval2", colorval2)
	get_material().set_shader_parameter("colorval3", colorval3)
	
	
func rand_colors():
	var i = ["colorval1", "colorval2", "colorval3"].pick_random()
	var new_value = randf_range(0.0, 0.3)
	var tween = get_tree().create_tween()
	tween.tween_property(self, i, new_value, 7)
	color_timer.wait_time = randf_range(7.0, 12.0)
	color_timer.start()
