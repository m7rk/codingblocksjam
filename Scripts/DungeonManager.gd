extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Tween").interpolate_property(get_node("Camera/FrontSprite"), "modulate", Color(1,1,1,1), Color(0,0,0,0), 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("Music/Main"), "volume_db", -80, 0, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").start()

func finish():
	get_node("Tween").interpolate_property(get_node("Camera/FrontSprite"), "modulate", Color(0,0,0,0), Color(1,1,1,1), 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("Music/Main"), "volume_db", 0, -80, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").start()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Scenes/ItemMenu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
