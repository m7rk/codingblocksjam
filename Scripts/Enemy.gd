extends KinematicBody2D

var SPEED = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Tween").interpolate_property(self, "scale", Vector2(1,1), Vector2(0,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var delt = global_position - (get_node("../../Player").global_position)
	move_and_slide(-delt.normalized() * SPEED)

func onHit():
	get_node("Tween").start()
	get_node("Death").play()

func _on_Tween_tween_all_completed():
	queue_free()
