extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var exiting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AppState.level_to_load += 1
	get_node("Tween").interpolate_property(get_node("Transitioner"), "modulate", Color(0,0,0,0), Color(1,1,1,1), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("AudioStreamPlayer"), "volume_db", 0, -80, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func _on_Tween_tween_all_completed():
	get_tree().change_scene("res://Scenes/Dungeon.tscn")

func _on_Button_pressed():
	exiting = true
	get_node("Tween").start()

func _process(delta):
	if(!exiting):
		get_node("Transitioner").modulate = lerp(get_node("Transitioner").modulate,Color(0,0,0,0), delta)


func _on_AudioStreamPlayer_finished():
	get_node("AudioStreamPlayer").play(1.14)
