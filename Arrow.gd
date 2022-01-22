extends Area2D
onready var arrow_sprite = get_node("ArrowSprite")

var SPEED = 300
var yvel = 0
var zvel = 0
var zgrav = 2
var arrow_init_y = -30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	arrow_sprite.position.y += zvel
	zvel += zgrav * delta
	if(arrow_sprite.position.y > 0):
		queue_free()
	position += delta * (Vector2(SPEED,yvel))

func set_arrow_target(x,y):
	# where should the arrow land, relative to the start position?
	
	# let's assume that time scales linearly with distance.
	var airtime = abs(Vector2(x,y).length() / SPEED)
	# let's start by solving for y first.
	# i do not know why i have to divide by ten here??
	zvel = (0.5 + -(0.5 * zgrav * airtime * airtime)) / airtime
	yvel = (y / airtime)
	


func _on_Arrow_body_entered(body):
	queue_free()
	body.queue_free()
