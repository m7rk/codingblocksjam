extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func fadeOut():
	get_node("Tween").interpolate_property(get_node("Main"), "volume_db", get_node("Main").volume_db, -80, 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("Boss"), "volume_db", get_node("Boss").volume_db, -80, 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("Intro"), "volume_db", get_node("Boss").volume_db, -80, 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").start()

func playSong(songname):
	get_node(songname).play()
	get_node(songname).volume_db = 0
