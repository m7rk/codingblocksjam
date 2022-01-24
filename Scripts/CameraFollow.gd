extends Camera2D

var PROGRESS_LINE = 300
var frozen = false
var endgame = false

var targ = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.x = (450 - PROGRESS_LINE) + get_node("../Player").global_position.x
	targ = global_position.x
	get_node("../LeftBarrier").global_position.x = get_node("../Player").global_position.x - PROGRESS_LINE

func backpack(delta):
	var x_qual = get_viewport().get_mouse_position().x < 500 + get_node("Backpack").position.x + get_node("Backpack").scale.x * 300 
	var y_qual = get_viewport().get_mouse_position().y < get_node("Backpack").position.y + get_node("Backpack").scale.y * 300
	if(x_qual && y_qual):
		get_node("Backpack").scale = lerp(get_node("Backpack").scale,Vector2(0.3,0.3),5*delta)
		get_node("Backpack").modulate = lerp(get_node("Backpack").modulate,Color(1,1,1,0.5),5*delta)
		get_node("Backpack").position = lerp(get_node("Backpack").position,Vector2(-400 + 100,50 + 100),5*delta)
		for i in get_node("Backpack").get_children():
			i.modulate = lerp(i.modulate,Color(1,1,1,2),5*delta)
	else:
		get_node("Backpack").scale = lerp(get_node("Backpack").scale,Vector2(0.1,0.1),5*delta)
		get_node("Backpack").modulate = lerp(get_node("Backpack").modulate,Color(1,1,1,1),5*delta)
		get_node("Backpack").position = lerp(get_node("Backpack").position,Vector2(-400,50),5*delta)
		for i in get_node("Backpack").get_children():
			i.modulate = lerp(i.modulate,Color(1,1,1,0),5*delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x = lerp(global_position.x, targ, 3 * delta)
	backpack(delta)
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


