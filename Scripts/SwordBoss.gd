extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var phase = "TAUNTING"
var active = false
# state = taunting 
# state = teleporting
# state = attacking
# state = injured

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Animation").play("Taunt")
	get_node("Tween").interpolate_property(get_node("CharacterRig"), "scale", Vector2(0.3,0.3), Vector2(0,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(active):
		if(phase == "TAUNTING"):
			pass

func onHit(bonus):
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
