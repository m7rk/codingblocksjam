extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var active = false
var SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if(active):
		var delt = global_position - (get_node("../../Player").global_position)
		move_and_slide(-delt.normalized() * SPEED)
		
func onHit():
	get_node("../../Music").fadeOut()
	get_node("CollisionShape2D").queue_free()
	get_node("CharacterRig").queue_free()
	yield(get_tree().create_timer(2.0), "timeout")
	get_node("../../Camera").frozen = false
	queue_free()
