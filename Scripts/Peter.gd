extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var SPEED = 220
var wait_time = 0

var dest = null
var state = "CURIOUS"

var fireball = preload("res://Scenes/FireAlly.tscn")

var confidence = 2
# PANICKED - run away from everything
# SCARED - injured, but not by the player
# CURIOUS - Wander around the player.
# PLEASED - normal behavior.
# CONFIDENT - attack enemies.
# CHEERFUL - attack enemies.

# LOSE BY FRIENDLY FIRE
var mean = 0
# UPSET - stay away from player
# ANGRY - attack anything within reach, stay away from player

onready var player =  get_node("../Player")
# LOSE COND
# UNTAMED - attack the player (possible game over)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Animation").play("Idle")
	if(AppState.bed):
		confidence += 1
	if(AppState.rope):
		confidence += 1
	if(AppState.brush):
		confidence += 1
	if(AppState.clippers):
		confidence += 1

func calcuateState():
	# you lose
	if(confidence <= -1 || mean >= 3):
		return "UNTAMED"

	# critical states
	if(mean == 2):
		return "ANGRY"
	if(confidence == 0):
		return "PANICKED"
		
			
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

func set_random_waypoint_behind_player():
	dest = player.global_position + Vector2(rand_range(-150,-50), rand_range(-50,50))
	# wait here for a minute
	wait_time = rand_range(0.3,0.6)
	if(dest.y > 500):
		dest = null
		
func set_random_waypoint_near_player():
	dest = player.global_position + Vector2(rand_range(-150,50), rand_range(-100,100))
	if((player.global_position - global_position).length() < 150):
		# wait here for a minute
		wait_time = rand_range(0.7,1.3)
	if(dest.y > 500 || (player.global_position - global_position).length() < 50):
		dest = null
		return

func set_random_waypoint():
	dest = player.global_position + Vector2(rand_range(-200,300), rand_range(-200,300))
	if(dest.y > 500):
		dest = null

func set_lead_player():
	dest = player.global_position + Vector2(rand_range(100,300), rand_range(-300,300))
	# wait here for a minute
	wait_time = rand_range(0.5,1.5)
	if(dest.y > 500):
		dest = null

func AI(delta):
	if(get_parent().finish_flag):
		move_and_slide(Vector2(SPEED,0))
		return

	if(wait_time > 0):
		wait_time -= delta
		return

	if(state == "CURIOUS" || state == "HUNGRY"):
		if(dest == null or global_position.distance_to(dest) < 10):
			set_random_waypoint_near_player()

	if(state == "UNTAMED"):
		dest = global_position + Vector2(0,-1000)
		if(global_position.y < -100):
			active = false

	if(state == "UPSET"):
		if(dest == null or global_position.distance_to(dest) < 10 or dest.x > player.global_position.x):
			set_random_waypoint()
			wait_time = rand_range(0.3,1.1)
		
	if(state == "ANGRY"):
		if(dest == null or global_position.distance_to(dest) < 10):
			set_random_waypoint()
	
	if(state == "STARVING" || state == "PANICKED"):
		if(dest == null or global_position.distance_to(dest) < 10):
			set_random_waypoint_behind_player()
	
	if(state == "SCARED"):
		if(dest == null or global_position.distance_to(dest) < 10):
			if(rand_range(0.0,1.0) < 0.5):
				set_random_waypoint_near_player()
			else:
				set_random_waypoint_behind_player()
	
	if(state == "PLEASED" || state == "CONFIDENT" || state == "CHEERFUL"):
		if(dest == null or global_position.distance_to(dest) < 10):
			set_lead_player()
		if(wait_time > 1):
			lfireball(Vector2(400,0))

	if(dest == null):
		return
	move_and_slide((dest - global_position).normalized() * SPEED)
	

func lfireball(v):
	var launched = fireball.instance()
	launched.set_velocity(v)
	launched.global_position = global_position
	get_parent().add_child(launched)
	get_node("Launch").play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(active):
		state = calcuateState()
		AI(delta)
		
func onHit(reward):
	confidence -= 1
	get_node("Hurt").play()
	
func friendlyFire():
	mean += 1
	get_node("Hurt2").play()
	
func scare():
	confidence -= 1

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

# lower mean amount.
# add confidence if we can.
func killBonus():
	if(!active):
		return
	if(mean > 0 and rand_range(0,1) < 0.5):
		mean -= 1
		return
	if(mean == 0 && rand_range(0.0,confidence + 0.1) < 0.5):
		confidence += 1
		confidence = min(confidence,5)
		get_node("Confident").play()

func killBossBonus():
	if(!active):
		return
	mean = 0
	confidence += 2
	confidence = min(confidence,5)
