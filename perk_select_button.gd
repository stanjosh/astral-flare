extends Button

@onready var title: RichTextLabel = $PerkSelectContainer/PanelContainer/VBoxContainer/MarginContainer2/Title
@onready var image: TextureRect = $PerkSelectContainer/PanelContainer/VBoxContainer/MarginContainer/Image
@onready var description: RichTextLabel = $PerkSelectContainer/PanelContainer/VBoxContainer/MarginContainer3/Description


var perk_info

func _update(perk_info):
	title.text = perk_info.title
	description.text = perk_info.description
	image.texture = perk_info.image
