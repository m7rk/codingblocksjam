extends Area2D

#2 arrays, one for the items you collected, one for the backpack
#Array collected[10]
#Array backpack[10]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_backpack_body_entered(body):
	print(body.get_type() + " put In")


func _on_backpack_body_exited(body):
	print("Take Out") # Replace with function body.
