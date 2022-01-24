extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var finish_flag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Tween").interpolate_property(get_node("Camera/FrontSprite"), "modulate", Color(1,1,1,1), Color(0,0,0,0), 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("Music/Main"), "volume_db", -80, 0, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").start()
		
	if(AppState.level_to_load == 1):
		get_node("Dungeon2").queue_free()
		get_node("Dungeon3").queue_free()
		
	if(AppState.level_to_load == 2):
		get_node("Dungeon1").queue_free()
		get_node("Dungeon3").queue_free()
		get_node("Peter").global_position = Vector2(200,200)
		get_node("Peter").visible = true
		get_node("Peter").active = true

	if(AppState.level_to_load == 3):
		get_node("Dungeon1").queue_free()
		get_node("Dungeon2").queue_free()
		get_node("Peter").global_position = Vector2(200,200)
		get_node("Peter").visible = true
		get_node("Peter").active = true

func finish():
	finish_flag = true
	get_node("Tween").interpolate_property(get_node("Camera/FrontSprite"), "modulate", Color(0,0,0,0), Color(1,1,1,1), 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("Music/Main"), "volume_db", 0, -80, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").start()
	yield(get_tree().create_timer(3.0), "timeout")
	if(AppState.level_to_load == 3):
		get_tree().change_scene("res://Scenes/End.tscn")
	else:
		AppState.stored_its = []
		for v in get_node("Camera/Backpack").get_children():
			AppState.stored_its.append([v.name.rstrip("0123456789"),v.position])
		get_tree().change_scene("res://Scenes/ItemMenu.tscn")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
