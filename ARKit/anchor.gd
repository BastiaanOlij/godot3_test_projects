extends ARVRAnchor

# should move this into a subscene so we can add anchors as new ones are registered

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	if get_is_active() == false:
		visible = false
	elif visible == false:
		visible = true
#		get_node("../../GodotBalls").translation = translation
