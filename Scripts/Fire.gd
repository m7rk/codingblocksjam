extends Area2D


# Declare member variables here. Examples:
# var a = 2
var vel = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position + vel * delta

func set_velocity(v):
	vel = v
