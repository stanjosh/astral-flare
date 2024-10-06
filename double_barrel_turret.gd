extends Node2D

@export var player : Player
@onready var barrel_1: Marker2D = $Barrel1
@onready var barrel_2: Marker2D = $Barrel2

const BULLET = preload("res://bullet.tscn")

var damage = 2

var barrel_one_or_two : bool = true
var projectile_origin : Vector2 :
	get:
		barrel_one_or_two = !barrel_one_or_two
		return barrel_1.global_position if barrel_one_or_two else barrel_2.global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		shoot()

func shoot() -> void:
		var bullet = BULLET.instantiate()
		bullet.global_position = projectile_origin
		bullet.global_rotation = global_rotation
		add_child(bullet)
