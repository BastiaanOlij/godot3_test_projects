extends Spatial

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var arkit = ARVRServer.find_interface('ARKit')
	if (arkit):
		print("Found ARKit")
		arkit.initialize()
		get_viewport().arvr = true
	else:
		print("Couldn't find ARKit")
