extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var SPEED = 190
var hunger = 100
var wait_time = 0

var dest = null
var state = "CURIOUS"
# GOOD STATES
# CURIOUS - Wander around the player.
# PLEASED - normal behavior.
# CONFIDENT - attack enemies.
# CHEERFUL - attack enemies.

# LOSE BY HUNGER
# HUNGRY - demand food, annoy the player.
# STARVING - demand food, annoy the player agressively.

# LOSE BY NO DEFENSE
# SCARED - injured, but not by the player
# PANICKED - run away from everything

# LOSE BY FRIENDLY FIRE
# UPSET - stay away from player
# ANGRY - attack anything within reach, stay away from player

# LOSE COND
# UNTAMED - attack the player (possible game over)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Animation").play("Idle")

func AI(delta):
	if(get_parent().finish_flag):
		move_and_slide(Vector2(SPEED,0))
		return

	var player =  get_node("../Player")
	if(wait_time > 0):
		wait_time -= delta
		return

	if(state == "CURIOUS"):
		if(dest == null or global_position.distance_to(dest) < 10):
			dest = player.global_position + Vector2(rand_range(-150,50), rand_range(-100,100))
			if((player.global_position - global_position).length() < 150):
				# wait here for a minute
				wait_time = rand_range(0.7,1.3)
			if(dest.y > 500 || (player.global_position - global_position).length() < 50):
				dest = null
				return
	move_and_slide((dest - global_position).normalized() * SPEED)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(active):
		var delt = global_position - (get_node("../Player").global_position)
		hunger -= delta
		AI(delta)
