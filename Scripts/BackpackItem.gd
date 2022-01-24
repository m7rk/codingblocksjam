extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Tween").interpolate_property(self, "modulate", Color(1,0,0,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func dissolve():
	get_node("Area2D").queue_free()
	get_node("Tween").start()


func _on_Tween_tween_all_completed():
	queue_free()
