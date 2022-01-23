extends Camera2D

var PROGRESS_LINE = 300
var frozen = false
var endgame = false

var targ = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.x = (450 - PROGRESS_LINE) + get_node("../Player").global_position.x
	get_node("../LeftBarrier").global_position.x = get_node("../Player").global_position.x - PROGRESS_LINE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x = lerp(global_position.x, targ, 3 * delta)
	if(endgame):
		if(get_node("../Player").global_position.x - 450 > global_position.x):
			get_parent().finish()
			endgame = false
			
	if(frozen):
		return
	if(get_node("../LeftBarrier").global_position.x < get_node("../Player").global_position.x - PROGRESS_LINE):
		get_node("../LeftBarrier").global_position.x = get_node("../Player").global_position.x - PROGRESS_LINE
		get_node("../RightBarrier").global_position.x = get_node("../Player").global_position.x - PROGRESS_LINE + 900
		targ = (450 - PROGRESS_LINE) + get_node("../Player").global_position.x

			
		
