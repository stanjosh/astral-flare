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
	for target in targets:
		if !is_instance_valid(weapon_nodes[weapon_index].target):
			weapon_nodes[weapon_index].target = target
		weapon_index += 1

func get_weapon_nodes() -> Array[Weapon]:
	var list : Array[Weapon]
	for n in weapons.get_children():
		if n is Weapon:
			list.push_back(n)
	return list


func _on_auto_aim_area_body_entered(body: Node2D) -> void:
	if not body in targets:
		targets.push_back(body)


func _on_auto_aim_area_body_exited(body: Node2D) -> void:
	if body in targets:
		targets.erase(body)
