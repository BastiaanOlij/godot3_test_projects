extends Spatial

var arkit = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var arkit = ARVRServer.find_interface('ARKit')
	if (arkit):
		print("Found ARKit")
		arkit.initialize()
		
		arkit.set_plane_detection_is_enabled(true)
		get_node("toggle_plane_detection").set_text("Turn plane detection off")
		
		get_viewport().arvr = true
	else:
		print("Couldn't find ARKit")
		get_node("toggle_plane_detection").set_text("No ARKIT")


func _on_toggle_plane_detection():
	if (arkit):
		if (arkit.get_plane_detection_is_enabled()):
			arkit.set_plane_detection_is_enabled(false)
			get_node("toggle_plane_detection").set_text("Turn plane detection on")
		else:
			arkit.set_plane_detection_is_enabled(true)
			get_node("toggle_plane_detection").set_text("Turn plane detection off")
