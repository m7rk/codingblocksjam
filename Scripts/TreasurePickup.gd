extends Area2D


# Declare member variables here. Examples:
# var a = 2
var it_type = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Treasure1_body_entered(body):
	if(get_node("../../Camera/Backpack").addItem(name)):
		queue_free()
		get_node("../../Player/GetTreasure").play()
