extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var phase = "TAUNTING"

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
	if(phase == "TAUNTING"):
		pass

func onHit():
	get_node("../../Music").fadeOut()
	get_node("../../Peter").killBossBonus()
	get_node("CollisionShape2D").queue_free()
	get_node("Tween").start()
	phase = "DEAD"
	yield(get_tree().create_timer(2.0), "timeout")
	get_node("../../Camera").frozen = false
	queue_free()
