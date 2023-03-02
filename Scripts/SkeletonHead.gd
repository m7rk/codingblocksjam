extends KinematicBody2D

var SPEED = 80

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Tween").interpolate_property(self, "scale", Vector2(0.8,0.8), Vector2(0,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(global_position.x - get_node("../../Player").global_position.x < 1000):
		var delt = global_position - (get_node("../../Player").global_position)
		move_and_slide(-delt.normalized() * SPEED)
		
	if(global_position.x - get_node("../../Player").global_position.x < -500):
		queue_free()
		
	var slide_count = get_slide_count()
	if slide_count:
		var collision = get_slide_collision(slide_count - 1)
		var collider = collision.collider
		if(collider.name == "Player"):
			collider.onHit(false)
			onHit(false)
			
	if(rand_range(0,1.0) < delta):
		get_node("Idle").play()

func onHit(bonus):
	get_node("Tween").start()
	get_node("Death").play()
	get_node("CollisionShape2D").queue_free()
	if(bonus):
		get_node("../../Peter").killBonus()

func _on_Tween_tween_all_completed():
	queue_free()

