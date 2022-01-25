extends Node2D

onready var arrow_sprite = get_node("ArrowSprite")
onready var alt_arrow_sprite = preload("res://Sprites/arrow_stuck.png")

var SPEED = 350
var xvel = 0
var yvel = 0
var zvel = 0
var zgrav = 6
var arrow_init_y = -30
var disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func impact():
	disabled = true
	get_node("ArrowSprite/Arrow/CShape").queue_free()
	get_node("ArrowSprite").texture = alt_arrow_sprite
	get_node("Impact").play()
	z_index = -899 #floor is -1000
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(disabled):
		return
	arrow_sprite.position.y += zvel
	zvel += zgrav * delta
	if(arrow_sprite.position.y > 0):
		impact()
	position += delta * (Vector2(xvel,yvel))
	# no idea why values are so small here so x 1000 lol
	get_node("ArrowSprite").rotation_degrees = 1500 * atan2(zvel,abs(Vector2(xvel,yvel).length()))

func set_arrow_target(x,y):
	# let's assume that time scales linearly with distance.
	var airtime = abs(Vector2(x,y).length() / SPEED)
	# let's start by solving for y first.
	# i do not know why i have to divide by ten here??
	zvel = (0.5 + -(0.5 * zgrav * airtime * airtime)) / airtime
	yvel = (y / airtime)
	xvel = (x / airtime)
	if(x < 0):
		scale = Vector2(-1,1)
	

func _on_Arrow_body_entered(body):
	queue_free()
	body.onHit(true)
	if(body.name == "Peter"):
		body.friendlyFire()
