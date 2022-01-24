extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hatch_body_entered(body):
	if(get_node("../../Egg").frame == 3):
		get_node("../../../Peter").visible = true
		get_node("../../../Peter").active = true
		get_node("../../../Music").playSong("Intro")
	queue_free()
	get_node("../../Egg").frame = get_node("../../Egg").frame + 1
	get_node("../../Egg/Crack").play()

