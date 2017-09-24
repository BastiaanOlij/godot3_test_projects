extends Spatial

var arkit = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	arkit = ARVRServer.find_interface('ARKit')
	if arkit:
		print("Found ARKit")
		arkit.initialize()
		
		arkit.set_plane_detection_is_enabled(true)
		get_node("toggle_plane_detection").set_text("Turn plane detection off")
		
		get_viewport().arvr = true
	else:
		print("Couldn't find ARKit")
		get_node("toggle_plane_detection").set_text("No ARKIT")


func _on_toggle_plane_detection():
	if arkit:
		if (arkit.get_plane_detection_is_enabled()):
			arkit.set_plane_detection_is_enabled(false)
			get_node("toggle_plane_detection").set_text("Turn plane detection on")
		else:
			arkit.set_plane_detection_is_enabled(true)
			get_node("toggle_plane_detection").set_text("Turn plane detection off")
			
func _process(delta):
	var info_text = "FPS: " + str(Engine.get_frames_per_second()) + "\n"

	if arkit:
		var status = arkit.get_tracking_status() 
		if status == 4:
			info_text += "Not tracking, move your device around for ARKit to detect features\n"
		elif status == 0:
			info_text += "Tracking a-ok\n"
		elif status == 1:
			info_text += "Insufficient tracking, moving your device to fast\n"
		elif status == 2:
			info_text += "Insufficient features, move further away or improve lighting conditions\n"
		else:
			info_text += "Unknown tracking status\n"
			
	$Info.text = info_text
