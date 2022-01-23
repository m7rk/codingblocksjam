extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Tween").interpolate_property(get_node("Sprite"), "modulate", Color(1,1,1,1), Color(0,0,0,1), 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("AudioStreamPlayer"), "volume_db", 0, -80, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").interpolate_property(get_node("Sprite").material, "shader_param/volume", 0.5, 3, 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_node("Tween").start()
		get_node("FrontSprite").queue_free()


func _on_Tween_tween_all_completed():
	get_tree().change_scene("res://Scenes/Dungeon.tscn")
