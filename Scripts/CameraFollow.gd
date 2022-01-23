extends Camera2D

var PROGRESS_LINE = 300
var frozen = false

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.x = (450 - PROGRESS_LINE) + get_node("../Player").global_position.x
	get_node("../LeftBarrier").global_position.x = get_node("../Player").global_position.x - PROGRESS_LINE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(frozen):
		return
	if(get_node("../LeftBarrier").global_position.x < get_node("../Player").global_position.x - PROGRESS_LINE):
		get_node("../LeftBarrier").global_position.x = get_node("../Player").global_position.x - PROGRESS_LINE
		get_node("../RightBarrier").global_position.x = get_node("../Player").global_position.x - PROGRESS_LINE + 900
		global_position.x = (450 - PROGRESS_LINE) + get_node("../Player").global_position.x
