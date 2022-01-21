extends KinematicBody2D

var SPEED = 200
# Declare member variables here. Examples:
var yvel = 2
var ygrav = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(Vector2(SPEED,0))
	if get_slide_count()==1:
		get_slide_collision(0).get_collider().queue_free()
		queue_free()
