extends KinematicBody2D
var arrow = preload("res://Scenes/Arrow.tscn")

# Declare member variables here. Examples:
var SPEED = 200

var AIM_SPEED = 60
# var b = "text"
var aimer_active = true
var aim_time = 0
var AIM_MAX = 2.5
var AIM_LIMIT = 2.0
var AIM_CURS_ROT_SPEED = 90

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	var raw_input = Vector2(0,0)
	if(Input.is_action_pressed("right")):
		raw_input = Vector2(1,0)
	if(Input.is_action_pressed("left")):
		raw_input = Vector2(-1,0)
	if(Input.is_action_pressed("up")):
		raw_input = Vector2(0,-1)
	if(Input.is_action_pressed("down")):
		raw_input = Vector2(0,1)
	
	if(raw_input != Vector2(0,0)):
		get_node("CharacterRig/Animator").play("Walk")
	else:
		get_node("CharacterRig/Animator").play("Idle")
	
	if(aimer_active):
		move_and_slide(AIM_SPEED * raw_input)
	else:
		move_and_slide(SPEED * raw_input)
	
	var target = Vector2(0,10000)
	
	if(aimer_active):
		target = Vector2(-450 + get_node("../Camera").global_position.x + get_viewport().get_mouse_position().x, get_viewport().get_mouse_position().y)
		aim_time += delta
		var aim_delt = -450  + (get_viewport().get_mouse_position().x + get_node("../Camera").global_position.x) - (global_position.x)
		get_node("CharacterRig").scale.x = 0.2 * sign(aim_delt)
		if(aim_time > AIM_LIMIT):
			aim_time = AIM_LIMIT
		rigAim(getAimerPosition())
	else:
		aim_time = 0
		get_node("../Aimer").rotation_degrees = 0
		
		
	get_node("../Aimer").global_position = target
	var aimscale = pow((AIM_MAX - aim_time) / AIM_MAX,0.8)
	get_node("../Aimer").global_scale = Vector2(aimscale,aimscale)
	get_node("../Aimer").rotation_degrees += AIM_CURS_ROT_SPEED * delta

func getAimerPosition():
	var target_x = get_viewport().get_mouse_position().x + get_node("../Camera").global_position.x
	var diff_x = target_x + -global_position.x + -450 # cam bias
	var diff_y = get_viewport().get_mouse_position().y - global_position.y
	return Vector2(diff_x,diff_y)

func isReversed():
	return sign(get_node("CharacterRig").scale.x) == -1
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		aimer_active = true
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !event.pressed:
		var instance = arrow.instance()
		get_parent().add_child(instance)
		instance.global_position = global_position
		instance.set_arrow_target(getAimerPosition()[0],getAimerPosition()[1]) 
		aimer_active = false
		
func rigAim(vec):
	if(isReversed()):
		# offset + rad to deg
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperRightArm").rotation_degrees = 180 + -50 + -57 * atan2(vec.y,vec.x)
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperLeftArm").rotation_degrees = 180 + -90 + -57 * atan2(vec.y,vec.x)
	else:
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperRightArm").rotation_degrees = -50 + 57 * atan2(vec.y,vec.x)
		get_node("CharacterRig/Pelvis/BoneTorso/Torso/BoneUpperLeftArm").rotation_degrees = -90 + 57 * atan2(vec.y,vec.x)
