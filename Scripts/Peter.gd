extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var SPEED = 220
var wait_time = 0

var dest = null

var fireball = preload("res://Scenes/FireAlly.tscn")

# out of 100
var confidence = 50
var anger = 0
# low confidence, flee from enemies, hide behind player
# high confidence, engage enemies

# low anger, avoid attacking player, stay close, attack less
# high anger, stay away from player, move erratically, attack more

onready var player =  get_node("../Player")

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
	anger = max(anger,0)
	confidence = min(confidence,100)
	
	if(get_parent().finish_flag):
		move_and_slide(Vector2(SPEED,0))
		return
	
	if(wait_time > 0):
		wait_time -= delta
		return

	# first check for extreme states
	if(anger >= 100 or confidence <= 0):
		dest = global_position + Vector2(0,-1000)
		if(global_position.y < -100):
			active = false
			
	elif(anger > 60):
		if(dest == null or global_position.distance_to(dest) < 10):
			set_random_waypoint()
	
	elif(confidence < 30):
		if(dest == null or global_position.distance_to(dest) < 10):
			set_random_waypoint_behind_player()
	
	# check for middling states

	elif(anger > 30):
		if(dest == null or global_position.distance_to(dest) < 10 or dest.x > player.global_position.x):
			set_random_waypoint()
			wait_time = rand_range(0.3,1.1)
		

	elif(confidence < 60):
		if(dest == null or global_position.distance_to(dest) < 10):
			set_random_waypoint_near_player()
	
	# here, anger is less than 30 and confidence is greater than 60
	else:
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
		AI(delta)
		
func onHit(reward):
	confidence -= 20
	get_node("Hurt").play()
	
func friendlyFire():
	anger += 25
	get_node("Hurt2").play()
	
func scare():
	if(!active):
		return
	confidence -= 10



# get_node("Confident").play() on change.

func killBonus():
	if(!active):
		return
	if(anger > 30):
		confidence += int(rand_range(1,3))
		return
	if(anger <= 30):
		confidence += int(rand_range(1,7))

func killBossBonus():
	if(!active):
		return
	confidence += 30
	confidence = min(confidence,100)
