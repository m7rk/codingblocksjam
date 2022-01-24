extends Sprite


# Declare member variables here. Examples:
var gold_treasure = preload("res://Scenes/GoldTreasure.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func addItem(itemname):
	var v = gold_treasure.instance()
	v.name = itemname
	add_child(v)
	v.position = Vector2(rand_range(-150,150),rand_range(-230,230))
	return true
