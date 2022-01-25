extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var exiting = false
var foodcnt = 0
var goldcnt = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	for v in AppState.stored_its:
		if(v[0] == "F"):
			foodcnt += 1
		else:
			goldcnt += 1
	
	var aset = int(rand_range(0,3))
	get_node("opt1").get_child((aset + 1) % 3).queue_free()
	get_node("opt1").get_child((aset + 2) % 3).queue_free()
	
	
	var bset = int(rand_range(0,3))
	get_node("opt2").get_child((bset + 1) % 3).queue_free()
	get_node("opt2").get_child((bset + 2) % 3).queue_free()
	
	
	var cset =int(rand_range(0,3))
	get_node("opt3").get_child((cset + 1) % 3).queue_free()
	get_node("opt3").get_child((cset + 2) % 3).queue_free()
		
	AppState.level_to_load += 1
	get_node("Tween").interpolate_property(get_node("Transitioner"), "modulate", Color(0,0,0,0), Color(1,1,1,1), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("AudioStreamPlayer"), "volume_db", 0, -80, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func _on_Tween_tween_all_completed():
	get_tree().change_scene("res://Scenes/Dungeon.tscn")

func _on_Button_pressed():
	exiting = true
	get_node("Tween").start()

func _process(delta):
	get_node("Label2").text = "FOOD: " + str(foodcnt) + "\nGOLD: " + str(goldcnt)
	if(!exiting):
		get_node("Transitioner").modulate = lerp(get_node("Transitioner").modulate,Color(0,0,0,0), delta)


func _on_AudioStreamPlayer_finished():
	get_node("AudioStreamPlayer").play(1.14)
