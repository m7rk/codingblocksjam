extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():

	if(id == 0 && get_parent().get_parent().get_parent().gold >= 2):
		get_parent().get_parent().get_parent().gold -= 2
		AppState.brush = true
	if(id == 1 && get_parent().get_parent().get_parent().gold >= 3):
		AppState.clippers = true
		get_parent().get_parent().get_parent().gold -= 3	
	if(id == 2 && get_parent().get_parent().get_parent().food >= 1):
		get_parent().get_parent().get_parent().food -= 1
		AppState.rope = true
		
	if(id == 3 && get_parent().get_parent().get_parent().gold >= 4):
		get_parent().get_parent().get_parent().gold -= 4
		AppState.lens = true
	if(id == 4 && get_parent().get_parent().get_parent().gold >= 2):
		get_parent().get_parent().get_parent().gold -= 2
		AppState.tape = true
	if(id == 5 && get_parent().get_parent().get_parent().food >= 4):
		get_parent().get_parent().get_parent().food -= 4
		AppState.string = true
		
	if(id == 6 && get_parent().get_parent().get_parent().gold >= 2):
		get_parent().get_parent().get_parent().gold -= 2
		AppState.bed = true
	if(id == 7 && get_parent().get_parent().get_parent().gold >= 3):
		get_parent().get_parent().get_parent().gold -= 3
		AppState.shoe = true
	if(id == 8 && get_parent().get_parent().get_parent().food >= 1):
		get_parent().get_parent().get_parent().food -= 1
		AppState.quiver = true
