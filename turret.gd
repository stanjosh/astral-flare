extends Node2D

@onready var weapons: Node2D = $Weapons
@onready var auto_aim_area: Area2D = $AutoAimArea


var targets : Array[Node2D]
var weapon_nodes : Array[Weapon]


func _ready() -> void:
	weapon_nodes = get_weapon_nodes()

func _process(delta: float) -> void:
	print(targets)
	for target in targets:
		for weapon in weapon_nodes:
			weapon.target = targets.pop_back()

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
