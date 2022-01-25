extends KinematicBody2D

var dragging = false

#variable to keep track of whehter it's in the inventory or not
var in_backpack = false
#determines whether it's food or an item or whatever
var item_type = "treasure"

signal dragsignal;

func _ready():
	connect("dragsignal",self,"_set_drag_pc")
	
	
func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.global_position = Vector2(mousepos.x, mousepos.y)

func get_type():
	return item_type

func _set_drag_pc():
	dragging=!dragging


func _on_KinematicBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.position = event.get_position()
		

