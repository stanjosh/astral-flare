extends Weapon

@export var player : Player
@onready var barrel_1: Marker2D = $Barrel1
@onready var barrel_2: Marker2D = $Barrel2
@onready var shot_timer: Timer = $ShotTimer

const BULLET = preload("res://bullet.tscn")

var barrel_one_or_two : bool = true
var projectile_origin : Vector2 :
	get:
		barrel_one_or_two = !barrel_one_or_two
		return barrel_1.global_position if barrel_one_or_two else barrel_2.global_position

func _input(event: InputEvent) -> void:
	if is_instance_valid(target):
		look_at(target.global_position)
		if shot_timer.is_stopped():
			shoot()

func shoot() -> void:
		shot_timer.start()
		var bullet = BULLET.instantiate()
		bullet.global_position = projectile_origin
		bullet.global_rotation = global_rotation
		add_child(bullet)
