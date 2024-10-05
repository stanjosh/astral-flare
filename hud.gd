extends CanvasLayer

@onready var xp_bar : ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer/XPBar
@onready var shield_bar: ProgressBar = $ShieldBar

var player : Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if player:
		shield_bar.position = player.get_global_transform_with_canvas().origin + Vector2(-12, 12)
