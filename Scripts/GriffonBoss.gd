extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var active = false
var SPEED = 400
var TARGET_START = Vector2(4650, 250)
onready var fireball = preload("res://Scenes/Fire.tscn")
# intro
# swoop left
# swoop right
# taunt?
var phase = "INTRO"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Animation").play("Idle")
	
func _physics_process(delta):
	if(active):
		if(phase == "INTRO"):
			move_and_slide((TARGET_START - global_position).normalized() * SPEED)
			if(TARGET_START.distance_to(global_position) < 5):
				phase = "IDLE"
		if(phase == "IDLE"):
			if(get_node("../../Player").draw_time > 1.5):
				phase = "SWOOP"
		if(phase == "SWOOP"):
			move_and_slide(Vector2(0,-1) * 2 * SPEED)
			if(global_position.y < 0):
				phase = "LEFTATTACK"
				global_position = TARGET_START + Vector2(500,0)
		if(phase == "LEFTATTACK"):
			move_and_slide(Vector2(-1,0) * 2 * SPEED)
			if(global_position.x < TARGET_START.x - 500):
				phase = "RIGHTATTACK"
			global_position = TARGET_START - Vector2(500,0)
		if(phase == "LEFTATTACK"):
			move_and_slide(Vector2(-1,0) * 2 * SPEED)
			if(global_position.x > TARGET_START.x + 500):
				phase = "INTRO"

func onHit():
	get_node("../../Music").fadeOut()
	get_node("CollisionShape2D").queue_free()
	get_node("CharacterRig").queue_free()
	yield(get_tree().create_timer(2.0), "timeout")
	get_node("../../Camera").frozen = false
	queue_free()
	
func fireball():
	var launched = fireball().instantiate()
	launched.global_position = global_position
	get_parent().add_child(launched)
