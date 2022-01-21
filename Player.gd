extends KinematicBody2D
var arrow = preload("res://Arrow.tscn")

# Declare member variables here. Examples:
var SPEED = 100
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if(Input.is_action_pressed("right")):
		move_and_slide(Vector2(SPEED,0))
	if(Input.is_action_pressed("left")):
		move_and_slide(Vector2(-SPEED,0))
	if(Input.is_action_pressed("up")):
		move_and_slide(Vector2(0,-SPEED))
	if(Input.is_action_pressed("down")):
		move_and_slide(Vector2(0,SPEED))

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print("Mouse Click/Unclick at: ", event.position)
		var instance = arrow.instance()
		get_parent().add_child(instance)
		instance.global_position = global_position
		
