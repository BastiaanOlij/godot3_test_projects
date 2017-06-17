extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$Viewport.set_attach_to_screen_rect(Rect2(Vector2(0.0, 0.0), Vector2(100.0, 100.0)))
