extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var SPEED = 190
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Animation").play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(active):
		var delt = global_position - (get_node("../Player").global_position)
		move_and_slide(-delt.normalized() * SPEED)
		print(global_position)
