extends KinematicBody2D
var arrow = preload("res://Scenes/Arrow.tscn")

# How fast when moving
var SPEED = 200
# How fast when aiming
var AIM_SPEED = 60

var aimer_active = false
var draw_time = 1

# aim variables, a smaller AIM_MAX increases accuracy bounds.
var aim_time = 0
var AIM_MAX = 1.3
var AIM_LIMIT = 1.0

var AIM_CURS_ROT_SPEED = 90
var ARROW_BONE_ROOT_POSITION = Vector2(9,33)
var CHAR_SCALE = 0.15

var RUNNING_MOD = 0.9

onready var arrow_node = get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperRightArm/UpperRightArm/LowerRightArm/Bow/ArrowBone")
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CharacterRig/UAnimator").play("Draw")
	arrow_node.visible = false
	if(AppState.shoe):
		SPEED = 300
	

func _physics_process(delta):
	var raw_input = Vector2(0,0)
	#check for diag
	if(Input.is_action_pressed("right") and Input.is_action_pressed("up")):
		raw_input = Vector2(0.71,-0.71)
	elif(Input.is_action_pressed("right") and Input.is_action_pressed("down")):
		raw_input = Vector2(0.71,0.71)
	elif(Input.is_action_pressed("left") and Input.is_action_pressed("up")):
		raw_input = Vector2(-0.71,-0.71)
	elif(Input.is_action_pressed("left") and Input.is_action_pressed("down")):
		raw_input = Vector2(-0.71,0.71)
	elif(Input.is_action_pressed("right")):
		raw_input = Vector2(1,0)
	elif(Input.is_action_pressed("left")):
		raw_input = Vector2(-1,0)
	elif(Input.is_action_pressed("up")):
		raw_input = Vector2(0,-1)
	elif(Input.is_action_pressed("down")):
		raw_input = Vector2(0,1)
		
	if(get_parent().finish_flag):
		raw_input = Vector2(1,0)
		
	if(raw_input != Vector2(0,0)):
		var runspeed = RUNNING_MOD
		if(aimer_active):
			runspeed = runspeed * (0.6)
		get_node("CharacterRig/LAnimator").play("Walk", -1, runspeed)
	else:
		get_node("CharacterRig/LAnimator").play("Idle")
	
	if(aimer_active):
		move_and_slide(AIM_SPEED * raw_input)
	else:
		move_and_slide(SPEED * raw_input)
	
	var target = Vector2(0,10000)
	
	if(!arrow_node.visible && draw_time <= 0.5):
		get_node("Nock").play()
		
	arrow_node.visible = draw_time <= 0.5

	
	#facing
	if(raw_input.x > 0):
		get_node("CharacterRig").scale.x = CHAR_SCALE
	if(raw_input.x < 0):
		get_node("CharacterRig").scale.x = -CHAR_SCALE
	
	if(draw_time >= 0):
		get_node("../Aimer").global_position = target
		draw_time -= delta
		if(AppState.quiver):
			draw_time -= delta

		return
	
	if(aimer_active):
		target = Vector2(-450 + get_node("../Camera").global_position.x + get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
		aim_time += delta
		var aim_delt = -450  + (get_viewport().get_mouse_position().x + get_node("../Camera").global_position.x) - (global_position.x)
		get_node("CharacterRig").scale.x = CHAR_SCALE * sign(aim_delt)
		if(sign(aim_delt) == 0):
			get_node("CharacterRig").scale.x = 1

		if(aim_time > AIM_LIMIT):
			aim_time = AIM_LIMIT
		
		arrow_node.visible = true
		arrow_node.position = ARROW_BONE_ROOT_POSITION + Vector2(-20*aim_time, -20*aim_time)
		rigAim(getAimerPosition())
	else:
		aim_time = 0
		get_node("../Aimer").rotation_degrees = 0
	
	get_node("../Aimer").global_position = target
	var aimscale = getAimScale()
	get_node("../Aimer").global_scale = Vector2(aimscale,aimscale)
	get_node("../Aimer").rotation_degrees += AIM_CURS_ROT_SPEED * delta

func getAimerPosition():
	var target_x = get_viewport().get_mouse_position().x + get_node("../Camera").global_position.x
	var diff_x = target_x + -arrow_node.global_position.x + -450 # cam bias
	var diff_y = get_viewport().get_mouse_position().y - arrow_node.global_position.y - 30
	return Vector2(diff_x,diff_y)

func addAimRandomness(R):
	var r = R * sqrt(rand_range(0.0,1.0))
	var theta = rand_range(0.0,1.0) * 2 * 3.14
	var x = r * cos(theta)
	var y = r * sin(theta)
	return Vector2(x,y)

func getAimScale():
	if(AppState.lens):
		return pow((AIM_MAX - aim_time) / AIM_MAX,0.8) / 3
	return pow((AIM_MAX - aim_time) / AIM_MAX,0.8)
	
func isReversed():
	return sign(get_node("CharacterRig").scale.x) == -1
	
func _input(event):
	if(draw_time > 0):
		return
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		aimer_active = true
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperLeftArm").rotation_degrees = 0
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperLeftArm/UpperLeftArm/BoneLowerLeftArm").rotation_degrees = 0
		get_node("CharacterRig/UAnimator").stop()
		get_node("BowPull").play()
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !event.pressed:
		if(aimer_active != true):
			return
			
		# this code is basically all bullshit
		var instance = arrow.instance()
		get_parent().add_child(instance)
		# little nudge to make arrow heads land better
		instance.global_position = arrow_node.global_position + Vector2(3,30)
		var rand = addAimRandomness(40 * getAimScale())
		instance.set_arrow_target(getAimerPosition()[0] + rand.x, getAimerPosition()[1] + rand.y) 
		aimer_active = false
		draw_time = 1
		get_node("CharacterRig/UAnimator").play("Draw")
		get_node("BowFire").play()
		
		
		if(AppState.tape):
			instance = arrow.instance()
			get_parent().add_child(instance)
			# little nudge to make arrow heads land better
			instance.global_position = arrow_node.global_position + Vector2(3,30)
			rand = addAimRandomness(40 * getAimScale())
			instance.set_arrow_target(getAimerPosition()[0] + rand.x, getAimerPosition()[1] + rand.y) 
			
		
func rigAim(vec):
	# properly animate the left arm
	var larm_targ_hi = -80
	var larm_targ_lo = -150
	#the offset we should use is a lerped over pi radians
	var offset = lerp(larm_targ_hi,larm_targ_lo, (1.57 + atan2(vec.y,vec.x)) / 3.14)
	if(vec.x < 0):
		offset = lerp(larm_targ_hi,larm_targ_lo, (1.57 + atan2(vec.y,-vec.x)) / 3.14)
		
	if(isReversed()):
		# offset + rad to deg
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperRightArm").rotation_degrees = (-180 + -55) + -57 * atan2(vec.y,vec.x)
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperLeftArm").rotation_degrees = (offset) + 57 * atan2(vec.y,-vec.x)
	else:
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperRightArm").rotation_degrees = -55 + 57 * atan2(vec.y,vec.x)
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperLeftArm").rotation_degrees = offset + 57 * atan2(vec.y,vec.x)

# lose an item when you get hit.
func onHit(bonus):
	if(get_node("../Camera/Backpack").get_child_count() > 0):
		var v = get_node("../Camera/Backpack").get_child(rand_range(0,get_node("../Camera/Backpack").get_child_count()))
		v.get_parent().remove_child(v)
		add_child(v)
		v.position = Vector2(0,-150)
		v.global_scale = Vector2(0.2,0.2)
		v.dissolve()
	if(rand_range(0,1.0) < 0.5):
		get_node("Hurt1").play()
	else:
		get_node("Hurt2").play()
	get_node("../Peter").scare()

func _on_UpperHitbox_body_entered(body):
	onHit(false)
	body.onHit(false)
