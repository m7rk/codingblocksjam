extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var phase = "TAUNTING"
var active = false
var HP = 3
var transition_time = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Animation").play("Taunt")
	get_node("Tween").interpolate_property(get_node("CharacterRig"), "scale", Vector2(0.3,0.3), Vector2(0,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(active):
		if(phase == "TAUNTING"):
			get_node("Animation").play("Taunt")
			transition_time -=  delta
			if(transition_time < 0):
				phase == "ATTACKING"
		if(phase == "ATTACKING"):
			get_node("Animation").play("Attack")
			move_and_slide(Vector2(-200,0))
			if(global_position.x < -500 + get_node("../../Player").x):
				phase = "ATTACKING"
				global_position.x = get_node("../../Player").x + 500
			
			
func onHit(bonus):
	if(phase == "ATTACKING"):
		HP -= 1
		if(HP == 0):
			get_node("../../Music").fadeOut()
			if(bonus):
				get_node("../../Peter").killBossBonus()
			get_node("CollisionShape2D").queue_free()
			get_node("Tween").start()
			phase = "DEAD"
			yield(get_tree().create_timer(2.0), "timeout")
			get_node("../../Camera").frozen = false
			get_node("../../Music").playSong("Main")
			queue_free()
	else:
		get_node("Animation").play("BlockHi")
		transition_time = 5
		
