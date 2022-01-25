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
	get_node("Tween").interpolate_property(get_node("CharacterRig"), "scale", Vector2(0.3,0.3), Vector2(0,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(active):
		if(phase == "TAUNTING"):
			transition_time -= delta
			if(transition_time > 4):
				get_node("Animation").play("BlockHi")
			else:
				get_node("Animation").play("Taunt")
			if(transition_time < 0):
				phase = "ATTACKING"
		if(phase == "ATTACKING"):
			get_node("Animation").play("Attack")
			move_and_slide(Vector2(-400,0))
			var slide_count = get_slide_count()
			if slide_count:
				var collision = get_slide_collision(slide_count - 1)
				var collider = collision.collider
				if(collider.name == "Player"):
					collider.onHit(false)
					phase = "TAUNTING"
					transition_time = 4
					global_position.x = get_node("../../Player").global_position.x + 400
			if(global_position.x < -400 + get_node("../../Player").global_position.x):
				phase = "TAUNTING"
				transition_time = 4
				global_position.x = get_node("../../Player").global_position.x + 400
	

			
			
			
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
		transition_time = 5
		
