extends ProgressBar

@onready var label: Label = $Label



func update(_value : int, _max_value : int):
	max_value = float(_max_value)
	value = float(_value)
	label.text = "%s / %s" % [value, max_value]
