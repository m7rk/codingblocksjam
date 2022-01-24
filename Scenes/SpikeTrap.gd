extends AnimatedSprite


# Declare member variables here. Examples:
var clock = 0
var rope_broke = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clock += delta

	if(clock > 4 and not rope_broke):
		clock = 0
		$Area2D.visible = false
	elif(clock > 3):
		frame = 6 * (4 - clock)
	elif(clock > 2):
		frame = 6
	elif(clock > 1):
		frame = 6 * (clock - 1)
		$Area2D.visible = true
	elif(clock > 0):
		frame = 0
		$Area2D.visible = false

func _on_Area2D_body_entered(body):
	body.onHit()
