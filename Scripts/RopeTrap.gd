extends Sprite


# Declare member variables here. Examples:
# var a = 2
onready var broke = load("res://Sprites/Rope/Rope2.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	get_node("Area2D").queue_free()
	texture = broke
	for v in get_children():
		if(v.name != "Area2D"):
			v.rope_broke = true
	pass # Replace with function body.
