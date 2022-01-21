extends KinematicBody2D

var SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var delt = global_position - (get_node("../../Player").global_position)
	move_and_slide(-delt.normalized() * SPEED)
