extends Node2D

@onready var weapons: Node2D = $Weapons
@onready var auto_aim_area: Area2D = $AutoAimArea
@onready var auto_aim_area_shape: CollisionShape2D = $AutoAimArea/AutoAimAreaShape


var targets : Array[Node2D]
var weapon_nodes : Array[Weapon]
@export var auto_aim_area_size : float = 72.0 :
	set(value):
		auto_aim_area_size = value
		auto_aim_area_shape.shape.radius = auto_aim_area_size


func _ready() -> void:
	weapon_nodes = get_weapon_nodes()

func _process(delta: float) -> void:
	if targets:
		assign_targets()
		

func assign_targets() -> void:
	var weapon_index = wrapi(0, 0, weapon_nodes.size() - 1)
	for target in auto_aim_area.get_overlapping_bodies():
		if target is Asteroid \
		and !is_instance_valid(weapon_nodes[weapon_index].target) \
		and target in auto_aim_area.get_overlapping_bodies():
			weapon_nodes[weapon_index].target = target
		weapon_index += 1

func get_weapon_nodes() -> Array[Weapon]:
	var list : Array[Weapon]
	for n in weapons.get_children():
		if n is Weapon:
			list.push_back(n)
	return list
