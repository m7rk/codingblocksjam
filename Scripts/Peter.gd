extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var SPEED = 190
var wait_time = 0

var dest = null
var state = "CURIOUS"

var confidence = 2
# PANICKED - run away from everything
# SCARED - injured, but not by the player
# CURIOUS - Wander around the player.
# PLEASED - normal behavior.
# CONFIDENT - attack enemies.
# CHEERFUL - attack enemies.

# counts up, has threshes.
var hunger = 0
# LOSE BY HUNGER
# HUNGRY - demand food, annoy the player.
# STARVING - demand food, annoy the player agressively.

# LOSE BY FRIENDLY FIRE
var mean = 0
# UPSET - stay away from player
# ANGRY - attack anything within reach, stay away from player

# LOSE COND
# UNTAMED - attack the player (possible game over)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Animation").play("Idle")

func calcuateState():
	# you lose
	if(hunger > 120 || confidence <= -1 || mean >= 3):
		return "UNTAMED"

	# critical states
	if(confidence == 0):
		return "PANICKED"
	if(hunger > 90):
		return "STARVING"
	if(mean == 2):
		return "ANGRY"
		
	# let the user know about hunger.
	if(hunger > 60):
		return "HUNGRY"
			
	# states that mean confidence is pretty low but you did something else kinda bad
	if(confidence == 1 || confidence == 2):
		if(mean == 1):
			return "UPSET"
		if(confidence == 1):
			return "SCARED"
		if(confidence == 2):
			return "CURIOUS"
			
	if(confidence == 3):
		# assert mean is 0 here
		return "PLEASED"
	if(confidence == 4):
		return "CONFIDENT"
	if(confidence == 5):
		return "CHEERFUL"

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
		state = calcuateState()
		var delt = global_position - (get_node("../Player").global_position)
		hunger += delta
		AI(delta)
		
func onHit():
	confidence -= 1
	
func friendlyFire():
	mean += 1
	
func colorLookup():
	if(state == "UNTAMED"):
		return Color(0.7,0,0,1)
	if(state == "PANICKED" || state == "STARVING" || state == "ANGRY"):
		return Color(1,0.4,0,1)
	if(state == "HUNGRY" || state == "UPSET" || state == "SCARED"):
		return Color(1,0.8,0,1)
	if(state == "CURIOUS"):
		return Color(0.2,0.2,1,1)
	if(state == "PLEASED"):
		return Color(0.2,0.4,0.8,1)
	if(state == "CONFIDENT"):
		return Color(0.2,0.8,0.4,1)
	if(state == "CHEERFUL"):
		return Color(0.2,1,0.2,1)
